import os
import random
from fastapi import FastAPI
import psycopg2

DB_HOST = os.getenv("DB_HOST", "haproxy")
DB_PORT = os.getenv("DB_PORT", "5000")
DB_NAME = os.getenv("POSTGRES_DB", "db")
DB_USER = os.getenv("POSTGRES_USER", "admin")
DB_PASS = os.getenv("POSTGRES_PASSWORD", "postgres")

app = FastAPI()

DB_URL = f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

def get_db():
    conn = psycopg2.connect(DB_URL)
    cur = conn.cursor()
    return conn, cur

@app.get("/oltp/profile/{user_id}")
def get_profile(user_id: int):
    conn, cur = get_db()
    cur.execute("""
        SELECT u.login, p.first_name, p.last_name 
        FROM person.users u
        JOIN person.personalities p ON u.personality_id = p.personality_id
        JOIN person.passwords pw ON u.password_id = pw.password_id
        WHERE u.user_id = %s
    """, (user_id,))
    res = cur.fetchone()
    conn.close()
    return {"login": res[0], "name": f"{res[1]} {res[2]}"} if res else {}

@app.post("/oltp/expense")
def create_expense():
    conn, cur = get_db()
    uid = random.randint(1, 1000)
    cur.execute("""
        INSERT INTO transaction.expense_transactions 
        (user_id, price, date, expense_transaction_type_id, subcategory_id, description)
        VALUES (%s, 100, NOW(), 1, 1, 'test')
        RETURNING expense_transaction_id
    """, (uid,))

    trans_id = cur.fetchone()[0]

    cur.execute("""
            INSERT INTO transaction.expense_approvals 
            (expense_transaction_id, approver_user_id, status, comment)
            VALUES (%s, %s, 'Pending', 'Auto-created')
        """, (trans_id, 1))
    
    cur.execute("""
            UPDATE person.users 
            SET total_spent = total_spent + %s 
            WHERE user_id = %s
        """, (100, uid))

    conn.commit()
    conn.close()
    return {"status": "ok"}

@app.get("/oltp/budget/{user_id}")
def get_budget(user_id: int):
    conn, cur = get_db()
    cur.execute("""
        SELECT bi.price, sc.name 
        FROM planning.budget_items bi
        JOIN dictionary.subcategories sc ON bi.subcategory_id = sc.subcategory_id
        WHERE bi.user_id = %s
        LIMIT 10
    """, (user_id,))
    res = [{"price": r[0], "category": r[1]} for r in cur.fetchall()]
    conn.close()
    return res

@app.get("/olap/stats")
def get_stats():
    conn, cur = get_db()
    cur.execute("""
        SELECT category_name, total_sum 
        FROM analytics.category_stats
        ORDER BY total_sum DESC
    """)
    res = [{"category": r[0], "sum": r[1]} for r in cur.fetchall()]
    conn.close()
    return res

@app.get("/olap/trend")
def get_trend():
    conn, cur = get_db()
    cur.execute("""
        SELECT month_start, total_sum 
        FROM analytics.monthly_income_trend
        ORDER BY month_start ASC
    """)
    res = [{"month": str(r[0]), "sum": r[1]} for r in cur.fetchall()]
    conn.close()
    return res

@app.post("/log/income")
def log_income():
    conn, cur = get_db()
    uid = random.randint(1, 1000)
    cur.execute("""
        INSERT INTO transaction.income_transactions 
        (user_id, price, date, income_transaction_type_id, category_id, description)
        VALUES (%s, 500, NOW(), 1, 1, 'log_event')
    """, (uid,))
    conn.commit()
    conn.close()
    return {"status": "ok"}
import http from 'k6/http';
import { check, sleep } from 'k6';
import { randomIntBetween } from 'https://jslib.k6.io/k6-utils/1.2.0/index.js';

const BASE_URL = 'http://workload:8000';

export let options = {
    stages: [
        { duration: '1m', target: 10 },
        { duration: '3m', target: 10 },
        { duration: '30s', target: 0 },
    ],

    summaryTrendStats: ['avg', 'min', 'med', 'max', 'p(90)', 'p(95)', 'p(99)'],

    thresholds: {
        'http_req_duration{name:GET /oltp/profile}': [],
        'http_req_duration{name:POST /oltp/expense}': [],
        'http_req_duration{name:GET /oltp/budget}': [],
        'http_req_duration{name:GET /olap/stats}': [],
        'http_req_duration{name:GET /olap/trend}': [],
        'http_req_duration{name:POST /log/income}': [],
    },
};

export default function () {
    const userId = randomIntBetween(1, 1000);

    // 1. OLTP
    let resProfile = http.get(`${BASE_URL}/oltp/profile/${userId}`, { tags: { name: 'GET /oltp/profile' } });
    check(resProfile, { 'profile is 200': (r) => r.status === 200 });

    // 2. OLTP
    let resExpense = http.post(`${BASE_URL}/oltp/expense`, {}, { tags: { name: 'POST /oltp/expense' } });
    check(resExpense, { 'expense is 200': (r) => r.status === 200 });

    // 3. OLTP
    let resBudget = http.get(`${BASE_URL}/oltp/budget/${userId}`, { tags: { name: 'GET /oltp/budget' } });
    check(resBudget, { 'budget is 200': (r) => r.status === 200 });

    // 4. OLAP
    let resStats = http.get(`${BASE_URL}/olap/stats`, { tags: { name: 'GET /olap/stats' } });
    check(resStats, { 'stats is 200': (r) => r.status === 200 });

    // 5. OLAP
    let resTrend = http.get(`${BASE_URL}/olap/trend`, { tags: { name: 'GET /olap/trend' } });
    check(resTrend, { 'trend is 200': (r) => r.status === 200 });

    // 6. LOG
    let resLog = http.post(`${BASE_URL}/log/income`, {}, { tags: { name: 'POST /log/income' } });
    check(resLog, { 'log is 200': (r) => r.status === 200 });

    sleep(1);
}
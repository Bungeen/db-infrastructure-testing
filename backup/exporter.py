from http.server import BaseHTTPRequestHandler, HTTPServer
from prometheus_client import generate_latest, Gauge
import os

LAST_BACKUP_TIME = Gauge('last_backup_timestamp_seconds', 'Timestamp of the last successful backup')
LAST_BACKUP_SIZE = Gauge('last_backup_size_bytes', 'Size of the last backup in bytes')

class MetricsHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/metrics':
            try:
                with open('/backups/metrics.prom', 'r') as f:
                    for line in f:
                        line = line.strip()
                        if not line or line.startswith('#'):
                            continue
                        
                        parts = line.split()
                        if len(parts) == 2:
                            name, value = parts
                            if name == 'last_backup_timestamp_seconds':
                                LAST_BACKUP_TIME.set(float(value))
                            elif name == 'last_backup_size_bytes':
                                LAST_BACKUP_SIZE.set(float(value))
            except FileNotFoundError:
                pass
            
            self.send_response(200)
            self.send_header('Content-type', 'text/plain; version=0.0.4')
            self.end_headers()
            self.wfile.write(generate_latest())
        else:
            self.send_response(404)
            self.end_headers()

if __name__ == '__main__':
    print("Starting backup exporter on port 8080...")
    server = HTTPServer(('0.0.0.0', 8080), MetricsHandler)
    server.serve_forever()
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/')
def index():
    client_cn = request.headers.get('X-SSL-Client-CN')
    if client_cn:
        return f"mTLS OK. Client CN: {client_cn}", 200
    else:
        return "No client certificate info received", 401

@app.route('/test')
def test():
    client_cn = request.headers.get('X-SSL-Client-CN')

    return jsonify({
        "message": "Test OK",
        "client_cn": client_cn or "No client certificate"
    })

@app.route('/secure-data')
def secure_data():
    client_cn = request.headers.get('X-SSL-Client-CN')
    if not client_cn:
        return jsonify({"error": "Client cert required"}), 403
    
    # info secreta ...

    return jsonify({
        "secret_data": "Password: abcdef...",
        "client_cn": client_cn
    })

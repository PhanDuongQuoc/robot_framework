from flask import Flask, request, jsonify, send_from_directory
from flask_pymongo import PyMongo
from bson.objectid import ObjectId
from flask_cors import CORS
import os

app = Flask(__name__, static_folder="../frontend", static_url_path="/")
CORS(app)
app.config["MONGO_URI"] = "mongodb://localhost:27017/products_db"
mongo = PyMongo(app)

@app.route("/")
def serve_index():
    return send_from_directory(app.static_folder, "index.html")

@app.route("/<path:filename>")
def serve_static_files(filename):
    return send_from_directory(app.static_folder, filename)

@app.route("/products", methods=["GET"])
def get_products():
    products = list(mongo.db.products.find())
    for product in products:
        product["_id"] = str(product["_id"])
    return jsonify(products)

@app.route("/product", methods=["POST"])
def add_product():
    data = request.json
    name = data.get("name", '').strip()  
    price = data.get("price",'').strip()  

    if not name or not price:
        return jsonify({"error": "Please provide valid product name and price."}), 400

    product_id = mongo.db.products.insert_one(data).inserted_id
    
    return jsonify({"_id": str(product_id)})


@app.route("/product/<id>", methods=["PUT"])
def update_product(id):
    data = request.json
    mongo.db.products.update_one({"_id": ObjectId(id)}, {"$set": data})
    return jsonify({"message": "Product updated"})


@app.route("/product/<id>", methods=["DELETE"])
def delete_product(id):
    mongo.db.products.delete_one({"_id": ObjectId(id)})
    return jsonify({"message": "Product deleted"})

if __name__ == "__main__":
    app.run(debug=True)

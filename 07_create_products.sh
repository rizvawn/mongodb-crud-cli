#!/bin/bash
# Skapar kollektionen products med fem produktdokument för referensuppslagning och CRUD-demonstration.
# Kör med: bash 07_create_products.sh
# Kräver: mongosh och att MongoDB körs i Docker-containern 'mongodb'

(docker exec -i mongodb mongosh "mongodb://localhost:27017/devops25_nosql" --quiet <<'EOF'

db.products.drop();

db.products.insertMany([
    { productId: "souvenir-01", name: "Stockholm Mug",         price: 120, category: "kitchen"      },
    { productId: "souvenir-02", name: "Swedish Flag Keychain", price:  50, category: "accessories"  },
    { productId: "souvenir-03", name: "Viking Helmet",         price: 350, category: "collectibles" },
    { productId: "souvenir-04", name: "Dala Horse Figurine",   price: 200, category: "collectibles" },
    { productId: "souvenir-05", name: "Postcard Set",          price:  30, category: "stationery"   }
]);

print("Documents in products collection: " + db.products.countDocuments());
print("\nAll products:");
db.products.find({}, { _id: 0 }).forEach(printjson);

EOF
)  | sed 's/^devops25_nosql> //'
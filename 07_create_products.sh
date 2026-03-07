#!/bin/bash
# Skapar kollektionen products med ett dokument för referensuppslagning.
# Kör med: bash 07_create_products.sh
# Kräver: mongosh och att MongoDB körs i Docker-containern 'mongodb'

(docker exec -i mongodb mongosh "mongodb://localhost:27017/devops25_nosql" --quiet <<'EOF'

db.products.drop();

db.products.insertOne(
   {
       productId: "souvenir-01",
        name: "Stockholm Mug",
        price: 120
    }
);

print("Documents in products collection: " + db.products.countDocuments());
print("\nProduct document:");
db.products.findOne({ productId: "souvenir-01" },{ _id: 0 });

EOF
)  | sed 's/^devops25_nosql> //'
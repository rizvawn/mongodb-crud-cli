#!/bin/bash
# Demonstrerar READ, UPDATE och DELETE mot devops25_nosql.products.
# Kör med: bash 12_crud_products.sh
# Kräver: mongosh och att MongoDB körs i Docker-containern 'mongodb'

(docker exec -i mongodb mongosh "mongodb://localhost:27017/devops25_nosql" --quiet <<'EOF'

// --- READ ---

// 1. Hämta alla produkter
print("\n== All products ==");
db.products.find({}, { _id: 0 }).forEach(printjson);

// 2. Filtrera produkter med pris under 100 SEK
print("\n== Products with price < 100 SEK ==");
db.products.find({ price: { $lt: 100 } }, { _id: 0 }).forEach(printjson);

// 3. Alla produkter sorterade på pris, lägst först
print("\n== All products sorted by price ascending ==");
db.products.find({}, { _id: 0 }).sort({ price: 1 }).forEach(printjson);


// --- UPDATE ---

// 4. Uppdatera priset på souvenir-02 med $set
print("\n== Before: update price for souvenir-02 ==");
db.products.findOne({ productId: "souvenir-02" }, { productId: 1, name: 1, price: 1, _id: 0 });

db.products.updateOne(
    { productId: "souvenir-02" },
    { $set: { price: 65 } }
);

print("== After: update price for souvenir-02 ==");
db.products.findOne({ productId: "souvenir-02" }, { productId: 1, name: 1, price: 1, _id: 0 });


// --- DELETE ---

// 5. Radera souvenir-05 med deleteOne
print("\n== Before deleteOne: count ==");
print("Total products: " + db.products.countDocuments());

db.products.deleteOne({ productId: "souvenir-05" });

print("\n== After deleteOne: count ==");
print("Total products: " + db.products.countDocuments());

const deleted = db.products.findOne({ productId: "souvenir-05" });
print("souvenir-05 exists: " + (deleted !== null));

EOF
) | sed 's/^devops25_nosql> //'

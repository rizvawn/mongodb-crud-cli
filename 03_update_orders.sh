#!/bin/bash
# Demonstrerar UPDATE-operationer mot devops25_nosql.orders.
# Kör med: bash 03_update_orders.sh
# Kräver: mongosh och att MongoDB körs i Docker-containern 'mongodb'

(docker exec -i mongodb mongosh "mongodb://localhost:27017/devops25_nosql" --quiet <<'EOF'

// --- 1. Ändra status på en order ---
// visitor-002:s order på 1320 SEK ändras från "pending" till "processing"
print("\n== Before: change status ==");
db.orders.findOne({ customerId: "visitor-002", totalAmount: 1320 }, { customerId: 1, status: 1, totalAmount: 1, _id: 0 });

db.orders.updateOne(
  { customerId: "visitor-002", totalAmount: 1320 },
  { $set: { status: "processing" } }
);

print("== After: change status ==");
db.orders.findOne({ customerId: "visitor-002", totalAmount: 1320 }, { customerId: 1, status: 1, totalAmount: 1, _id: 0 });


// --- 2. Lägg till en ny produkt i items-arrayen ---
// visitor-003:s order på 1090 SEK får en ny produkt tillagd
print("\n== Before: push new item ==");
db.orders.findOne({ customerId: "visitor-003", totalAmount: 1090 }, { customerId: 1, items: 1, totalAmount: 1, _id: 0 });

db.orders.updateOne(
  { customerId: "visitor-003", totalAmount: 1090 },
  { $push: { items: { productId: "souvenir-19", name: "Nobel Prize Bookmark", quantity: 2, price: 45 } } }
);

print("== After: push new item ==");
db.orders.findOne({ customerId: "visitor-003", totalAmount: 1090 }, { customerId: 1, items: 1, totalAmount: 1, _id: 0 });


// --- 3. Öka totalAmount med ett visst belopp ---
// Samma order uppdateras med det tillkommande beloppet (2 × 45 = 90 SEK)
print("\n== Before: increment totalAmount ==");
db.orders.findOne({ customerId: "visitor-003", totalAmount: 1090 }, { customerId: 1, totalAmount: 1, _id: 0 });

db.orders.updateOne(
  { customerId: "visitor-003", totalAmount: 1090 },
  { $inc: { totalAmount: 90 } }
);

print("== After: increment totalAmount ==");
db.orders.findOne({ customerId: "visitor-003", totalAmount: 1180 }, { customerId: 1, totalAmount: 1, _id: 0 });

EOF
) | grep -v -x '^devops25_nosql>'
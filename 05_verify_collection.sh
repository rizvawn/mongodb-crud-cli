#!/bin/bash
# Verifierar slutresultatet av hela CRUD-övningen mot devops25_nosql.orders.
# Kör med: bash 05_verify_collection.sh
# Kräver: mongosh och att MongoDB körs i Docker-containern 'mongodb'

(docker exec -i mongodb mongosh "mongodb://localhost:27017/devops25_nosql" --quiet <<'EOF'

// --- 1. Bekräfta att kollektionen innehåller exakt 10 dokument ---
print("\n== Total documents in collection ==");
print(db.orders.countDocuments());


// --- 2. Visa det uppdaterade dokumentet: status ändrad till "processing" ---
print("\n== Updated document: visitor-002 status changed to processing ==");
db.orders.findOne(
  { customerId: "visitor-002", status: "processing" },
  { customerId: 1, totalAmount: 1, status: 1, _id: 0 }
);


// --- 3. Visa det uppdaterade dokumentet: Nobel Prize Bookmark tillagd + totalAmount 1180 ---
print("\n== Updated document: visitor-003 with pushed item and incremented totalAmount ==");
db.orders.findOne(
  { customerId: "visitor-003", totalAmount: 1180 },
  { customerId: 1, items: 1, totalAmount: 1, _id: 0 }
);


// --- 4. Bekräfta att det raderade dokumentet är borta ---
print("\n== Verify deleted: cancelled order for visitor-005 (Sami Bracelet) ==");
const deleted = db.orders.findOne({ customerId: "visitor-005", status: "cancelled" });
print(deleted === null ? "Confirmed: document does not exist" : "WARNING: document still exists");


// --- 5. Bekräfta att småordrar är borta ---
print("\n== Verify deleted: orders with totalAmount < 115 ==");
print("Count: " + db.orders.countDocuments({ totalAmount: { $lt: 115 } }));


// --- 6. Visa att filtret totalAmount > 1000 fungerar ---
print("\n== Working filter: orders with totalAmount > 1000 ==");
db.orders.find(
  { totalAmount: { $gt: 1000 } },
  { customerId: 1, totalAmount: 1, status: 1, _id: 0 }
).sort({ totalAmount: -1 }).forEach(printjson);


// --- 7. Fullständig slutvy av kollektionen ---
print("\n== Final state of collection ==");
db.orders.find(
  {},
  { customerId: 1, totalAmount: 1, status: 1, createdAt: 1, _id: 0 }
).sort({ totalAmount: -1 }).forEach(printjson);

EOF
) | sed 's/^devops25_nosql> //'
#!/bin/bash
# Demonstrerar DELETE-operationer mot devops25_nosql.orders.
# Kör med: bash 04_delete_orders.sh
# Kräver: mongosh och att MongoDB körs i Docker-containern 'mongodb'

(docker exec -i mongodb mongosh "mongodb://localhost:27017/devops25_nosql" --quiet <<'EOF'

// --- 1. Radera ett specifikt dokument med deleteOne ---
// Tar bort den avbrutna ordern för visitor-005 (Sami Bracelet, 1250 SEK)
print("\n== Before deleteOne: count ==");
print("Total documents: " + db.orders.countDocuments());

db.orders.deleteOne({ customerId: "visitor-005", status: "cancelled" });

print("\n== After deleteOne: count ==");
print("Total documents: " + db.orders.countDocuments());

// Bekräfta att dokumentet är borta
print("Cancelled orders remaining for visitor-005:");
print(db.orders.countDocuments({ customerId: "visitor-005", status: "cancelled" }));

// --- 2. Radera flera dokument med ett filter via deletMany ---
// Tar bort alla ordrar med totalAmount under 115 SEK (småordrar utan affärsvärde)
print("\n== Before deleteMany: orders with totalAmount < 115 ==");
db.orders.find(
    { totalAmount: { $lt: 115 } },
    { customerId: 1, totalAmount: 1, status: 1, _id: 0 }
).forEach(printjson);

db.orders.deleteMany({ totalAmount: { $lt: 115 } });

print("\n== After deleteMany: count ==");
print("Total documents: " + db.orders.countDocuments());

// --- Slutkontroll ---
print("\n== Final collection (customerId + totalAmount) ==");
db.orders.find(
    {},
    { customerId: 1, totalAmount: 1, status: 1, _id: 0 }
).sort({ totalAmount: -1 }).forEach(printjson);

EOF
) | grep -v -x '^devops25_nosql>'
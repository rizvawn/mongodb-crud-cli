#!/bin/bash
# Demonstrerar READ-operationer mot devops25_nosql.orders.
# Kör med: bash 02_read_orders.sh
# Kräver: mongosh och att MongoDB körs i Docker-containern 'mongodb'

(docker exec -i mongodb mongosh "mongodb://localhost:27017/devops25_nosql" --quiet <<'EOF'

// --- 1. Alla ordrar för en specifik kund ---
print("\n== Orders for visitor-003 ==");

db.orders.find(
    { customerId: "visitor-003" }
).forEach(printjson);

// --- 2. Ordrar där totalAmount överstiger 1000 SEK ---
print("\n== Orders with totalAmount > 1000 SEK ==");

db.orders.find(
    { totalAmount: { $gt: 1000 } }
).forEach(printjson);

// --- 3. Alla ordrar sorterade på totalAmount, högst först ---
print("\n== All orders sorted by totalAmount descending ==");

db.orders.find(
    {},
    { customerId: 1, totalAmount: 1, status: 1, _id: 0 }
).sort({ totalAmount: -1 }).forEach(printjson);

// --- 4. De fem dyraste ordrarna ---
print("\n== Top 5 orders by totalAmount ==");

db.orders.find(
    {},
    { customerId: 1, totalAmount: 1, status: 1, _id: 0 }
).sort({ totalAmount: -1 }).limit(5).forEach(printjson);

EOF
) | sed 's/^devops25_nosql> //'
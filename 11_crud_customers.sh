#!/bin/bash
# Demonstrerar READ, UPDATE och DELETE mot devops25_nosql.customers.
# Kör med: bash 11_crud_customers.sh
# Kräver: mongosh och att MongoDB körs i Docker-containern 'mongodb'

(docker exec -i mongodb mongosh "mongodb://localhost:27017/devops25_nosql" --quiet <<'EOF'

// --- READ ---

// 1. Hämta alla kunder
print("\n== All customers ==");
db.customers.find({}, { _id: 0 }).forEach(printjson);

// 2. Hämta en specifik kund via customerId
print("\n== Find customer: visitor-003 ==");
db.customers.findOne({ customerId: "visitor-003" }, { _id: 0 });

// 3. Alla kunder sorterade på namn i bokstavsordning
print("\n== All customers sorted by name ==");
db.customers.find({}, { _id: 0 }).sort({ name: 1 }).forEach(printjson);


// --- UPDATE ---

// 4. Uppdatera e-postadressen för visitor-004 med $set
print("\n== Before: update email for visitor-004 ==");
db.customers.findOne({ customerId: "visitor-004" }, { customerId: 1, email: 1, _id: 0 });

db.customers.updateOne(
    { customerId: "visitor-004" },
    { $set: { email: "lars.eriksson@updated.se" } }
);

print("== After: update email for visitor-004 ==");
db.customers.findOne({ customerId: "visitor-004" }, { customerId: 1, email: 1, _id: 0 });


// --- DELETE ---

// 5. Radera en kund med deleteOne
print("\n== Before deleteOne: count ==");
print("Total customers: " + db.customers.countDocuments());

db.customers.deleteOne({ customerId: "visitor-005" });

print("\n== After deleteOne: count ==");
print("Total customers: " + db.customers.countDocuments());

const deleted = db.customers.findOne({ customerId: "visitor-005" });
print("visitor-005 exists: " + (deleted !== null));

EOF
) | sed 's/^devops25_nosql> //'

# MongoDB: Från grunden via Linux CLI

Detta projekt är en övning med MongoDB där fokus ligger på de mest grundläggande
koncepten.

### Varför Bash och CLI?
Efter att nyligen ha arbetat på Linux och terminalmiljön föll det sig
naturligt att genomföra denna övning helt och hållet via kommandoraden. Istället för
att använda MongoDB Atlas + Compass har jag valt att strukturera hela processen i en serie Bash-skript.

Detta tillvägagångssätt ger flera fördelar:

- **Automatisering**: Varje steg i processen är repeterbart och dokumenterat i kod.
- **Renhet**: Genom att använda MongoDB Shell (`mongosh`) direkt ser man exakt hur databasen svarar utan abstraktionslager.
- **Miljöhantering**: Genom att köra MongoDB i Docker säkerställs en isolerad och ren utvecklingsmiljö som är lätt att sätta upp och ta bort.

### Projektets struktur
Övningen använder databasen `devops25_nosql` med kollektionen `orders`. Arbetet är uppdelat i fem numrerade Bash-skript som körs stegvis, ett per fas av CRUD-cykeln: skapa, läsa, uppdatera och radera dokument.

Innan skripten körs startas MongoDB med ett enkelt Docker-kommando:
`docker run -d --name mongodb -p 27017:27017 mongo:latest`
Därefter är `mongosh` tillgängligt mot `localhost:27017`.

### Steg 1: Skapa dokument (Create)
Skriptet `01_create_seed_orders.sh` skapar kollektionen `orders` i databasen `devops25_nosql` och fyller den med femton orderdokument från en fiktiv svensk souvenirbutik. Fem kunder används genomgående i datan, identifierade som `visitor-001` till `visitor-005`. Produktsortimentet består av arton distinkta souvenirer, från dalahästar och vikingahjälmar till samiska armband och lapplandshalsdukar. Fältet `totalAmount` är förutsummat utifrån kvantitet och pris per produkt. Statusalternativen som förekommer är `delivered`, `shipped`, `pending` och `cancelled`. Anslutningen till MongoDB sker via `docker exec` mot en körande container.

### Steg 2: Hämta dokument (Read)
Skriptet `02_read_orders.sh` visar fyra olika sätt att läsa data från kollektionen. Först hämtas samtliga ordrar kopplade till en enskild kund med ett exakt matchningsfilter. Därefter används en jämförelseoperator för att hitta ordrar vars `totalAmount` överstiger 1000 kronor. Sedan sorteras hela kollektionen på `totalAmount` i fallande ordning för att ge en överblick av köpen efter värde. Slutligen kombineras sortering och begränsning för att returnera de fem dyraste ordrarna. Projektionsparametern används för att hålla utdata läsbar.

### Steg 3: Uppdatera dokument (Update)
Skriptet `03_update_orders.sh` visar tre distinkta uppdateringsoperationer. Med `$set` ändras statusen på visitor-002:s order från `pending` till `processing`. Med `$push` läggs en ny produkt till i `items`-arrayen på visitor-003:s order utan att skriva om hela arrayen. Med `$inc` ökas `totalAmount` med exakt det belopp som den nya produkten tillförde. Varje operation omges av ett `findOne`-anrop före och efter för att göra förändringen synlig i utdata. Vid upprepade körningar bör skriptet föregås av `01_create_seed_orders.sh` för att återställa datan, alternativt kan dokumentets `_id` användas som filter för att garantera ett exakt träff.

### Steg 4: Radera dokument (Delete)
Skriptet `04_delete_orders.sh` demonstrerar två raderingsoperationer. Med `deleteOne` tas den avbrutna ordern för `visitor-005` bort, ett mönster som speglar hur avbrutna transaktioner kan rensas från en aktiv kollektion. Med `deleteMany` raderas samtliga ordrar vars `totalAmount` understiger 115 kronor, vilket visar hur ett villkorsbaserat filter kan påverka flera dokument i ett enda anrop. Antalet kvarvarande dokument skrivs ut efter varje operation och kollektionen ska efter detta steg innehålla exakt tio dokument.
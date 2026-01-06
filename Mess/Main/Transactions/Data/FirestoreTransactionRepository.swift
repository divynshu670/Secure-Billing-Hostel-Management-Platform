import Foundation
import FirebaseFirestore

class FirestoreTransactionRepository: TransactionRepository {
    private let db = Firestore.firestore()
    
    func getTransactions(uid: String) async throws -> [Transaction] {
        let snapshot = try await db.collection("users").document(uid)
            .collection("transactions")
            .order(by: "date", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: Transaction.self)
        }
    }
    
    func getTransaction(uid: String, id: String) async throws -> Transaction? {
        let doc = try await db.collection("users").document(uid)
            .collection("transactions")
            .document(id)
            .getDocument()
        
        return try doc.data(as: Transaction.self)
    }
}

import Foundation
import FirebaseFirestore

class FirestoreBillingRepository: BillingRepository {
    private let db = Firestore.firestore()
    
    func getPayments(uid: String) async throws -> [Payment] {
        let snapshot = try await db.collection("users").document(uid)
            .collection("payments")
            .order(by: "dueDate", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: Payment.self)
        }
    }
    
    func getPayment(uid: String, id: String) async throws -> Payment? {
        let doc = try await db.collection("users").document(uid)
            .collection("payments")
            .document(id)
            .getDocument()
        
        return try doc.data(as: Payment.self)
    }
    
    func makePayment(uid: String, paymentId: String, amount: Double) async throws -> Bool {
        try await db.collection("users").document(uid)
            .collection("payments")
            .document(paymentId)
            .updateData([
                "status": "Paid",
                "paidDate": Date()
            ])
        return true
    }
}

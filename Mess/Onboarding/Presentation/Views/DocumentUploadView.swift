import SwiftUI

struct DocumentUploadView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showFilePicker = false
    @State private var selectedDocumentType: DocumentType?
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: { viewModel.previousStep() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.appPrimary)
                }
                Spacer()
                Text("Upload Documents")
                    .headlineLarge()
                Spacer()
                Color.clear.frame(width: 44)
            }
            .padding(.horizontal, 16)
            
            ProgressView(value: viewModel.state.currentStep.progress)
                .tint(.appPrimary)
                .padding(.horizontal, 16)
            
            ScrollView {
                VStack(spacing: 16) {
                    Text("Upload at least 2 documents to proceed")
                        .font(AppTypography.bodyMedium)
                        .foregroundColor(.appSecondary)
                    
                    VStack(spacing: 12) {
                        ForEach(DocumentType.allCases, id: \.self) { documentType in
                            DocumentUploadCard(
                                documentType: documentType,
                                isUploaded: viewModel.state.uploadedDocuments[documentType] != nil,
                                onTap: {
                                    selectedDocumentType = documentType
                                    showFilePicker = true
                                }
                            )
                        }
                    }
                    
                    if let errorMessage = viewModel.state.errorMessage {
                        Text(errorMessage)
                            .font(AppTypography.bodySmall)
                            .foregroundColor(.appError)
                            .padding(12)
                            .background(Color.appError.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 16)
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: { viewModel.nextStep() }) {
                    if viewModel.state.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Continue")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(viewModel.requiredDocumentsUploaded ? Color.appPrimary : Color.appPrimary.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(!viewModel.requiredDocumentsUploaded || viewModel.state.isLoading)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color.appBackground)
        .sheet(isPresented: $showFilePicker) {
            FilePicker { url in
                if let docType = selectedDocumentType {
                    viewModel.addDocument(type: docType, fileUrl: url.lastPathComponent)
                }
                showFilePicker = false
            }
        }
    }
}

struct DocumentUploadCard: View {
    let documentType: DocumentType
    let isUploaded: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: isUploaded ? "checkmark.circle.fill" : "document.fill")
                    .font(.system(size: 24))
                    .foregroundColor(isUploaded ? .appSuccess : .appPrimary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(documentType.displayName)
                        .font(AppTypography.labelLarge)
                        .foregroundColor(.appPrimary)
                    Text(isUploaded ? "Uploaded" : "Not uploaded")
                        .font(AppTypography.bodySmall)
                        .foregroundColor(.appSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.appSecondary)
            }
            .padding(12)
            .background(Color.appSurface)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isUploaded ? Color.appSuccess : Color.appPrimary.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

#Preview {
    DocumentUploadView(viewModel: OnboardingViewModel(sessionStore: DefaultSessionStore()))
}

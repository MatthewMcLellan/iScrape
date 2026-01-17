import SwiftUI

struct DiscussionThreadView: View {
    @Environment(\.dismiss) private var dismiss

    struct Message: Identifiable, Hashable {
        let id = UUID()
        let author: String
        let text: String
        let date: Date
    }
    
    @State private var messages: [Message] = [
        Message(author: "System", text: "Welcome to the Hire-r discussion!", date: Date())
    ]
    @State private var author: String = ""
    @State private var draft: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(messages) { message in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(message.author.isEmpty ? "Anonymous" : message.author)
                                .font(.subheadline).bold()
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(Self.relativeDateFormatter.string(for: message.date)!)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Text(message.text)
                            .font(.body)
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.plain)
            
            Divider()
            
            inputBar
                .background(.ultraThinMaterial)
        }
        .navigationTitle("Hire-r Discussion")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") { dismiss() }
            }
        }
    }
    
    private var inputBar: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                TextField("Your name (optional)", text: $author)
                    .textFieldStyle(.roundedBorder)
                
                Spacer(minLength: 0)
            }
            
            HStack(spacing: 8) {
                TextField("Type a message…", text: $draft, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...4)
                    .onSubmit(postMessage)
                
                Button(action: postMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 17, weight: .semibold))
                }
                .buttonStyle(.borderedProminent)
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    private func postMessage() {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let new = Message(author: author.trimmingCharacters(in: .whitespacesAndNewlines), text: trimmed, date: Date())
        withAnimation {
            messages.append(new)
        }
        draft.removeAll()
    }
    
    private static let relativeDateFormatter: RelativeDateTimeFormatter = {
        let f = RelativeDateTimeFormatter()
        f.unitsStyle = .short
        return f
    }()
}

#Preview {
    NavigationView {
        DiscussionThreadView()
    }
}

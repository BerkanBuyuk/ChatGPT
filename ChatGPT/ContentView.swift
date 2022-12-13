//
//  ContentView.swift
//  ChatGPT
//
//  Created by Berkan on 13.12.2022.
//

import SwiftUI
import OpenAISwift


final class ViewModel: ObservableObject {
    init() {}
    
    private var client: OpenAISwift?
    
    func setup() {
        let APIkey = "Burada APIKey var."
        client = OpenAISwift(authToken: APIkey)
    }
    
    func send(text: String, completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text, maxTokens: 500 ,completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(output)
            case .failure:
                break
            }
        })
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(models, id: \.self) {string in
                Text(string)
            }
            Spacer()
            
            HStack {
                TextField("Buraya yazın..." ,text: $text)
                Button("Gönder") {
                    send()
                }
            }
        }
        .onAppear {
            viewModel.setup()
        }
        .padding()
    }
    
    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        models.append("Berkan: \(text)")
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                self.models.append("ChatGPT: " + response)
                self.text = ""
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

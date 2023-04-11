//
//  ExportGachaView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2023/4/3.
//

import SwiftUI
import UniformTypeIdentifiers

// MARK: - ExportGachaView

@available(iOS 15.0, *)
struct ExportGachaView: View {
    @EnvironmentObject
    var viewModel: ViewModel
    @StateObject
    var gachaViewModel: GachaViewModel = .shared

    @Binding
    var isSheetShow: Bool

    @ObservedObject
    fileprivate var params: ExportGachaParams = .init()

    @State
    private var isExporterPresented: Bool = false

    @State
    private var uigfJson: UIGFJson?

    @State
    fileprivate var alert: AlertType? {
        didSet {
            if let alert = alert {
                switch alert {
                case .succeed:
                    isSucceedAlertShow = true
                case .failure:
                    isFailureAlertShow = true
                }
            } else {
                isSucceedAlertShow = false
                isFailureAlertShow = false
            }
        }
    }

    var defaultFileName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        return "UIGF_\(uigfJson?.info.uid ?? "")_\(dateFormatter.string(from: uigfJson?.info.exportTime ?? Date()))"
    }

    fileprivate var file: JsonFile? {
        if let json = uigfJson {
            return .init(model: json)
        } else {
            return nil
        }
    }

    @ViewBuilder
    func main() -> some View {
        List {
            Section {
                Picker("选择帐号", selection: $params.uid) {
                    Group {
                        if params.uid == nil {
                            Text("未选择").tag(String?(nil))
                        }
                        ForEach(
                            gachaViewModel.allAvaliableAccountUID,
                            id: \.self
                        ) { uid in
                            if let name = viewModel.accounts
                                .first(where: { $0.config.uid! == uid })?.config
                                .name {
                                Text("\(name) (\(uid))")
                                    .tag(Optional(uid))
                            } else {
                                Text("\(uid)")
                                    .tag(Optional(uid))
                            }
                        }
                    }
                }
            }
            Section {
                Picker("选择语言", selection: $params.lang) {
                    ForEach(GachaLanguageCode.allCases, id: \.rawValue) { code in
                        Text(code.description).tag(code)
                    }
                }
                .disabled(true)
            } footer: {
                Text("UIGF多语言支持仍在讨论中，导出功能目前仅支持简体中文。我们会在其完成的第一时间添加对多语言的支持。")
            }
        }
    }

    var body: some View {
        NavigationView {
            main()
                .navigationTitle("导出祈愿记录")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("取消") {
                            isSheetShow.toggle()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("导出") {
                            let uid = params.uid!
                            let items = gachaViewModel.manager.fetchAllMO(uid: uid)
                                .map { $0.toUIGFGahcaItem(params.lang) }
                            uigfJson = .init(
                                info: .init(uid: uid, lang: params.lang),
                                list: items
                            )
                            isExporterPresented.toggle()
                        }
                        .disabled(params.uid == nil)
                    }
                }
                .alert("保存成功", isPresented: $isSucceedAlertShow, presenting: alert, actions: { _ in
                    Button("好") {
                        isSucceedAlertShow = false
                    }
                }, message: { thisAlert in
                    switch thisAlert {
                    case let .succeed(url):
                        Text("文件已保存至\(url)")
                    default:
                        EmptyView()
                    }
                })
                .alert("保存失败", isPresented: $isFailureAlertShow, presenting: alert, actions: { _ in
                    Button("好") {
                        isFailureAlertShow = false
                    }
                }, message: { thisAlert in
                    switch thisAlert {
                    case let .failure(error):
                        Text("错误信息：\(error)")
                    default:
                        EmptyView()
                    }
                })
                .fileExporter(
                    isPresented: $isExporterPresented,
                    document: file,
                    contentType: .json,
                    defaultFilename: defaultFileName
                ) { result in
                    switch result {
                    case let .success(url):
                        alert = .succeed(url: url.absoluteString)
                    case let .failure(failure):
                        alert = .failure(message: failure.localizedDescription)
                    }
                }
        }
    }

    @State
    private var isSucceedAlertShow: Bool = false
    @State
    private var isFailureAlertShow: Bool = false
}

// MARK: - ExportGachaParams

private class ExportGachaParams: ObservableObject {
    @Published
    var uid: String?
    @Published
    var lang: GachaLanguageCode = .zhCN
}

// MARK: - JsonFile

private struct JsonFile: FileDocument {
    // MARK: Lifecycle

    init(configuration: ReadConfiguration) throws {
        self.model = try JSONDecoder()
            .decode(
                UIGFJson.self,
                from: configuration.file.regularFileContents!
            )
    }

    init(model: UIGFJson) {
        self.model = model
    }

    // MARK: Internal

    static var readableContentTypes: [UTType] = [.json]

    let model: UIGFJson

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(model)
        return FileWrapper(regularFileWithContents: data)
    }
}

// MARK: - AlertType

private enum AlertType: Identifiable {
    case succeed(url: String)
    case failure(message: String)

    // MARK: Internal

    var id: String {
        switch self {
        case .succeed:
            return "succeed"
        case .failure:
            return "failure"
        }
    }
}

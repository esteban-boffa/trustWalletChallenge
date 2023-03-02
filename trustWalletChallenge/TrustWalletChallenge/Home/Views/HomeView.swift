//
//  HomeView.swift
//  TrustWalletChallenge
//
//  Created by Esteban Boffa on 28/02/2023.
//

import SwiftUI

struct HomeView: View, ViewControllableProtocol {

    typealias Constants = HomeViewModel.Constants

    // MARK: Private Properties

    @State private var showingDeleteAlert = false
    @State private var showingCommitAlert = false
    @State private var showingRollbackAlert = false
    @State private var showingEmptyValueAlert = false
    @State private var getKey = ""
    @State private var setKey = ""
    @State private var setValue = ""
    @State private var countValue = ""
    @State private var deleteKey = ""

    // MARK: Properties

    @ObservedObject var viewModel: HomeViewModel

    // MARK: Body

    var body: some View {
        List {
            Section {
                VStack {
                    HStack {
                        Button {
                            if !getKey.isEmpty {
                                viewModel.didTapGetButton(with: getKey)
                            } else {
                                showingEmptyValueAlert = true
                            }
                        } label: {
                            ButtonView(title: Constants.getButtonTitle)
                        }.buttonStyle(PlainButtonStyle())
                        .alert(
                            Constants.emptyValueAlertMessage,
                            isPresented: $showingEmptyValueAlert,
                            actions: { Button(Constants.okTitle, role: .none, action: {}) }
                        )
                        Spacer()
                        VStack {
                            TextField("", text: $getKey)
                                .textFieldStyle()
                                .onChange(of: getKey) { value in
                                    getKey = value
                                }
                            Text(Constants.keyTitle)
                                .subtitleStyle()
                        }
                        .offset(x: -4, y: 12)
                        Spacer()
                        Spacer()
                    }
                    HStack {
                        Text("\(Constants.outputTitle): \(viewModel.getValue)")
                        Spacer()
                    }
                    .padding(.top, 8)
                }
                VStack {
                    HStack {
                        Button {
                            if !setKey.isEmpty, !setValue.isEmpty {
                                viewModel.didTapSetButton(key: setKey, value: setValue)
                            } else {
                                showingEmptyValueAlert = true
                            }
                        } label: {
                            ButtonView(title: Constants.setButtonTitle)
                        }.buttonStyle(PlainButtonStyle())
                        .alert(
                            Constants.emptyValueAlertMessage,
                            isPresented: $showingEmptyValueAlert,
                            actions: { Button(Constants.okTitle, role: .none, action: {}) }
                        )
                        Spacer()
                        VStack {
                            TextField("", text: $setKey)
                                .textFieldStyle()
                                .onChange(of: setKey) { value in
                                    setKey = value
                                }
                            Text(Constants.keyTitle)
                                .subtitleStyle()
                        }
                        .offset(y: 12)
                        VStack {
                            TextField("", text: $setValue)
                                .textFieldStyle()
                                .onChange(of: setValue) { value in
                                    setValue = value
                                }
                            Text(Constants.valueTitle)
                                .subtitleStyle()
                        }
                        .offset(y: 12)
                    }
                    .padding(.bottom, 10)
                }
                VStack {
                    HStack {
                        Button {
                            if !countValue.isEmpty {
                                viewModel.didTapCountButton(for: countValue)
                            } else {
                                showingEmptyValueAlert = true
                            }
                        } label: {
                            ButtonView(title: Constants.countButtonTitle)
                        }.buttonStyle(PlainButtonStyle())
                        .alert(
                            Constants.emptyValueAlertMessage,
                            isPresented: $showingEmptyValueAlert,
                            actions: { Button(Constants.okTitle, role: .none, action: {}) }
                        )
                        Spacer()
                        VStack {
                            TextField("", text: $countValue)
                                .textFieldStyle()
                                .onChange(of: countValue) { value in
                                    countValue = value
                                }
                            Text(Constants.valueTitle)
                                .subtitleStyle()
                        }
                        .offset(x: -4, y: 12)
                        Spacer()
                        Spacer()
                    }
                    HStack {
                        Text("\(Constants.outputTitle): \(viewModel.countValue)")
                        Spacer()
                    }
                    .padding(.top, 8)
                }
                VStack {
                    HStack {
                        Button {
                            if !deleteKey.isEmpty {
                                showingDeleteAlert = true
                            } else {
                                showingEmptyValueAlert = true
                            }
                        } label: {
                            ButtonView(title: Constants.deleteButtonTitle)
                        }.buttonStyle(PlainButtonStyle())
                        .alert(
                            Constants.emptyValueAlertMessage,
                            isPresented: $showingEmptyValueAlert,
                            actions: { Button(Constants.okTitle, role: .none, action: {}) }
                        )
                        .alert(
                            Constants.deleteAlertMessageConfirmation,
                            isPresented: $showingDeleteAlert,
                            actions: {
                                Button(Constants.noAlertTitle, role: .none, action: {})
                                Button(Constants.yesAlertTitle, role: .none, action: {
                                    viewModel.didTapDeleteButton(for: deleteKey)
                                })
                            }
                        )
                        Spacer()
                        VStack {
                            TextField("", text: $deleteKey)
                                .textFieldStyle()
                                .onChange(of: deleteKey) { value in
                                    deleteKey = value
                                }
                            Text(Constants.keyTitle)
                                .subtitleStyle()
                        }
                        .offset(x: -4, y: 12)
                        Spacer()
                        Spacer()
                    }
                    .padding(.bottom, 10)
                }
            } header: {
                Text(Constants.commandsTitle)
                    .font(.headline)
            }

            Section {
                VStack {
                    HStack(spacing: 20) {
                        Button {
                            resetValues()
                            viewModel.resetValues()
                            viewModel.didTapBeginButton()
                        } label: {
                            ButtonView(title: Constants.beginButtonTitle)
                        }.buttonStyle(PlainButtonStyle())
                        Button {
                            showingCommitAlert = true
                        } label: {
                            ButtonView(title: Constants.commitButtonTitle)
                        }.buttonStyle(PlainButtonStyle())
                            .alert(
                                Constants.commitAlertMessageConfirmation,
                                isPresented: $showingCommitAlert,
                                actions: {
                                    Button(Constants.noAlertTitle, role: .none, action: {})
                                    Button(Constants.yesAlertTitle, role: .none, action: {
                                        viewModel.didTapCommitButton()
                                    })
                                }
                            )
                            .alert(
                                Constants.commitAlertMessage,
                                isPresented: $viewModel.showingCommitErrorAlert,
                                actions: { Button(Constants.okTitle, role: .none, action: {}) }
                            )
                        Button {
                            showingRollbackAlert = true
                        } label: {
                            ButtonView(title: Constants.rollbackButtonTitle)
                        }.buttonStyle(PlainButtonStyle())
                            .alert(
                                Constants.rollbackAlertMessageConfirmation,
                                isPresented: $showingRollbackAlert,
                                actions: {
                                    Button(Constants.noAlertTitle, role: .none, action: {})
                                    Button(Constants.yesAlertTitle, role: .none, action: {
                                        viewModel.didTapRollbackButton()
                                    })
                                }
                            )
                            .alert(
                                Constants.rollbackAlertMessage,
                                isPresented: $viewModel.showingRollbackErrorAlert,
                                actions: { Button(Constants.okTitle, role: .none, action: {}) }
                            )
                    }
                    HStack {
                        Text("\(Constants.processingText) \(viewModel.transactionsCounter) \(Constants.transactionsText)")
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                        Spacer()
                    }
                }
            } header: {
                Text(Constants.operationsTitle)
                    .font(.headline)
            }
            .listRowBackground(Color.clear)
        }
    }

    // MARK: Private methods

    private func resetValues() {
        setValue = ""
        countValue = ""
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}

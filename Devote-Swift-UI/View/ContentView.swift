//
//  ContentView.swift
//  Devote-Swift-UI
//
//  Created by Haziq Abdullah on 06/05/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTY
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    
    // MARK: - FETCHING DATA
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    // MARK: - FUNCTION
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            
            ZStack {
                // MARK: - MAIN VIEW
                
                VStack {
                    // MARK: - HEADER
                    
                    HStack(spacing: 10) {
                        
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                            .foregroundColor(isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white)
                        
                        Spacer()
                        
                        EditButton()
                            .foregroundColor(isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white)
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 10)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(Capsule().stroke(isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white, lineWidth: 2))
                        
                        Button(action: {
                            isDarkMode.toggle()
                            playSound(sound: "sound-tap", type: "mp3")
                            feedback.notificationOccurred(.success)
                        }, label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "sun.max.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                                .foregroundColor(isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white)
                        })
                    }
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 80)
                    
                    // MARK: - NEW TASK BUTTON
                    
                    Button(action: {
                        showNewTaskItem = true
                        playSound(sound: "sound-ding", type: "mp3")
                        feedback.notificationOccurred(.success)
                    }, label: {
                        
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                            .foregroundColor(isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white)
                        
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white)
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.pink, Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ).clipShape(Capsule())
                    )
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
                    
                    // MARK: - TASKS
                    
                    List {
                        
                        ForEach(items) { item in
                            
                            ListRowItemView(item: item)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .listStyle(.insetGrouped)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                }
                .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5))
                
                // MARK: - NEW TASK ITEM
                
                if showNewTaskItem {
                    BlankView(
                        backgroundColor: isDarkMode ? Color.black : Color.gray,
                        backgroundOpacity: isDarkMode ? 0.3 : 0.5)
                        .onTapGesture {
                            withAnimation() {
                                showNewTaskItem = false
                            }
                        }
                    
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
            }
            .navigationBarTitle("Daily Tasks", displayMode: .large)
            .navigationBarHidden(true)
            .background(BackgroundImageView()
                .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false))
            .background(backgroundGradient.ignoresSafeArea(.all))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - PREVIEW

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

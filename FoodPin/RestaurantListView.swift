//
//  ContentView.swift
//  FoodPin
//
//  Created by Stephen Lin on 2/5/24.
//
// Hello!

import SwiftUI
import SwiftData

struct RestaurantListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @State var restaurants = [
    Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location:
    "Hong Kong", image: "cafedeadend", isFavorite: false),
    Restaurant(name: "Homei", type: "Cafe", location: "Hong Kong", image:
    "homei", isFavorite: false),
    Restaurant(name: "Teakha", type: "Tea House", location: "Hong Kong", image: "teakha", isFavorite: false),
    Restaurant(name: "Cafe loisl", type: "Austrian / Causual Drink", location: "Hong Kong", image: "cafeloisl", isFavorite: false),
    Restaurant(name: "Petite Oyster", type: "French", location: "Hong Kong"
    , image: "petiteoyster", isFavorite: false),
    Restaurant(name: "For Kee Restaurant", type: "Bakery", location: "Hong Kong", image: "forkee", isFavorite: false),
    Restaurant(name: "Po's Atelier", type: "Bakery", location: "Hong Kong"
    , image: "posatelier", isFavorite: false),
    Restaurant(name: "Bourke Street Backery", type: "Chocolate", location:
    "Sydney", image: "bourkestreetbakery", isFavorite: false),
    Restaurant(name: "Haigh's Chocolate", type: "Cafe", location: "Sydney"
    , image: "haigh", isFavorite: false),
    Restaurant(name: "Palomino Espresso", type: "American / Seafood", location: "Sydney", image: "palomino", isFavorite: false),
    Restaurant(name: "Upstate", type: "American", location: "New York", image: "upstate", isFavorite: false),
    Restaurant(name: "Traif", type: "American", location: "New York", image: "traif", isFavorite: false),
    Restaurant(name: "Graham Avenue Meats", type: "Breakfast & Brunch", location: "New York", image: "graham", isFavorite: false),
    Restaurant(name: "Waffle & Wolf", type: "Coffee & Tea", location: "New York", image: "waffleandwolf", isFavorite: false),
    Restaurant(name: "Five Leaves", type: "Coffee & Tea", location: "New York", image: "fiveleaves", isFavorite: false),
    Restaurant(name: "Cafe Lore", type: "Latin American", location: "New York", image: "cafelore", isFavorite: false),
    Restaurant(name: "Confessional", type: "Spanish", location: "New York"
    , image: "confessional", isFavorite: false),
    Restaurant(name: "Barrafina", type: "Spanish", location: "London", image: "barrafina", isFavorite: false),
    Restaurant(name: "Donostia", type: "Spanish", location: "London", image: "donostia", isFavorite: false),
    Restaurant(name: "Royal Oak", type: "British", location: "London", image: "royaloak", isFavorite: false),
    Restaurant(name: "CASK Pub and Kitchen", type: "Thai", location: "London", image: "cask", isFavorite: false)]

    var body: some View {
        NavigationView {
            List {
                ForEach(restaurants.indices, id: \.self) { index in
                    ZStack {
                        NavigationLink(destination: RestaurantDetailView(restaurant: restaurants[index])){
                            EmptyView()
                        }
                        .opacity(0)
                            .swipeActions(edge: .leading, allowsFullSwipe: false, content:{
                                Button{
                                    
                                } label: {
                                    Image(systemName: "heart")
                                    .tint(.green)
                                }
                                Button{
                                    
                                } label: {
                                    Image(systemName: "square.and.arrow.up")
                                }
                                .tint(.orange)
                        })
                        BasicTextImageRow(restaurant: $restaurants[index])
                    }
                }
                .onDelete(perform: {indexSet in restaurants.remove(atOffsets: indexSet)})
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("FoodPin")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

struct RestaurantListView_Previews: PreviewProvider{
    static var previews: some View{
        RestaurantListView()
        
        RestaurantListView()
            .preferredColorScheme(.dark)
    }
}

struct BasicTextImageRow: View {
    
    @Binding var restaurant: Restaurant
    @State private var showOptions = false
    @State private var showError = false
 
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(restaurant.image)
                .resizable()
                .frame(height: 200)
                .cornerRadius(20)
            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.system(.title2, design: .rounded))
                Text(restaurant.type)
                    .font(.system(.body, design: .rounded))
                Text(restaurant.location)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.gray)
                if restaurant.isFavorite {
                    Spacer()
                    Image(systemName: "heart.fill")
                        .foregroundColor(.yellow)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .contextMenu{
            Button(action: {
                self.showError.toggle()
            }) {
                HStack{
                    Text("Reserve a table")
                    Image(systemName: "phone")
                }
            }
            Button(action: {
                self.restaurant.isFavorite.toggle()
            }) {
                HStack{
                    Text(restaurant.isFavorite ? "Remove from favorites" : "Mark as favorite")
                    Image(systemName: "heart")
                }
            }
            Button(action:{
                self.showOptions.toggle()
            }){
                HStack{
                    Text("Share")
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
        }
        .alert(isPresented: $showError){
            Alert(title: Text("Not yet available"),
                  message: Text("Sorry, this feature is not available yet. Please retry later."),
                  primaryButton: .default(Text("OK")),
                  secondaryButton: .cancel())
        }
        .sheet(isPresented: $showOptions){
            let defaultText = "Just checking in at \(restaurant.name)"
            
            if let imageToShare = UIImage(named: restaurant.image){
                ActivityView(activityItems: [defaultText, imageToShare])
            }
            else{
                ActivityView(activityItems: [defaultText])
            }
        }
    }
}

struct FullImageRow: View {
    
    var imageName: String
    var name: String
    var type: String
    var location: String
    @State private var showOptions = false
    @State private var showError = false
    @Binding var isFavorite: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .cornerRadius(20)
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(.title2, design: .rounded))
                Text(type)
                    .font(.system(.body, design: .rounded))
                Text(location)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.gray)
                if isFavorite {
                    Spacer()
                    Image(systemName: "heart.fill")
                        .foregroundColor(.yellow)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onTapGesture{
            showOptions.toggle()
        }
        .actionSheet(isPresented: $showOptions){
            ActionSheet(title: Text("What do you want to do?"),
                        message: nil,
                        buttons: [
                            .default(Text("Reserve a table")){
                                self.showError.toggle()
                            },
                            .default(Text("Mark as favorite")){
                                self.isFavorite.toggle()
                            },
                            .cancel()
                            ])
        
        }
        .alert(isPresented: $showError){
            Alert(title: Text("Not yet available"),
                  message: Text("Sorry, this feature is not available yet. Please retry later."),
                  primaryButton: .default(Text("OK")),
                  secondaryButton: .cancel())
        }
    }
}

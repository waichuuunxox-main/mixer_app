import SwiftUI
import WidgetKit

struct MediumWidgetView: View {
    var entry: SimpleEntry
    var body: some View {
        ZStack {
            Color(.systemBackground)
            HStack {
                VStack(alignment: .leading) {
                    Text("Next Match").font(.caption)
                    Text(entry.nextMatch).font(.title2).lineLimit(2)
                }
                Spacer()
                Image(systemName: "soccerball")
            }.padding()
        }
    }
}

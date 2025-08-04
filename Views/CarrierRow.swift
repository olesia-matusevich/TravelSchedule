import SwiftUI

struct CarrierRow: View {
    
    let serviceInfo: ServiceInformation
    private let stackHeight: Double = 104
    private let logoSize: Double = 38
    
    init(serviceInfo: ServiceInformation) {
        self.serviceInfo = serviceInfo
    }
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image("mock_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 38, height: 38)
                    .cornerRadius(12)
                    .frame(maxHeight: .infinity, alignment: .center)
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(serviceInfo.carrierTitle)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(Color.black)
                        
                        if serviceInfo.isTransfer {
                            Text("С пересадкой в \(serviceInfo.transferStation ?? "")")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(Color.redUniversal)
                        }
                    }
                    Spacer()
                    Text(serviceInfo.date)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(Color.black)
                }
            }
            HStack {
                Text(serviceInfo.departureTime)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color.black)
                
                Rectangle()
                    .fill(Color.grayUniversal)
                    .frame(height: 1)
                
                Text("\(serviceInfo.journeyTime) часов")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.black)
                
                Rectangle()
                    .fill(Color.grayUniversal)
                    .frame(height: 1)
                
                Text(serviceInfo.arrivalTime)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color.black)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .frame(height: stackHeight)
        .background(Color.lightGray)
        .clipShape(.rect(cornerRadius: 24))
        .listRowBackground(Color.customWhite)
    }
}

#Preview {
    
    CarrierRow(serviceInfo: ServiceInformation(departureTime: "11:50", arrivalTime: "11:50", carrierCode: "БелЖД", imageURL: URL(filePath: "https://www.figma.com"), carrierTitle: "БелЖД", isTransfer: false, transferStation: "Костроме", journeyTime: 10, date: "3 августа"))
}

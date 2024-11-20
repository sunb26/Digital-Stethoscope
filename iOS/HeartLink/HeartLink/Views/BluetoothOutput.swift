//
//  BluetoothOutput.swift
//  HeartLink
//
//  Created by Matt Wilker on 20/11/2024.
//

import SwiftUI

struct BluetoothOutput: View {
    @State var startBT: Bool = false
    @State var VStackPos: Int8 = 0

    var body: some View {
        VStack{
            
            HStack {
                
                Text("BT Testing Values:")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .frame(height: 20)
                
                Button(action: {
                    startBT.toggle()
                })
                {
                    Image(systemName: "stop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                }
            }
            
            ForEach(0...9, id: \.self) { number in
                if startBT == true {
                    Text("Val: \(number)") // replace this with values receive from BT
                        .font(.system(size: 12, weight: .black))
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("Values Done")
                        .font(.system(size: 12, weight: .black))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
            /*
            if startBT == true {
                Text("Val: ")
                    .font(.system(size: 12, weight: .black))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .frame(height: 20)
            } else {
                Text("Values Done")
                    .font(.system(size: 12, weight: .black))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .frame(height: 20)
            }*/
            
            
            
            Text(" ") // taking up white space
                .font(.system(size: 42, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 300)
        }
    }
}

#Preview {
    BluetoothOutput()
}

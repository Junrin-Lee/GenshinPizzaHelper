//
//  MaterialView.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/8/24.
//

import SwiftUI

struct MaterialView: View {
    var today: MaterialWeekday = .today()
    var talentMaterialProvider: TalentMaterialProvider { .init(weekday: today) }
    var weaponMaterialProvider: WeaponMaterialProvider { .init(weekday: today) }

    var body: some View {
        if Calendar.current.dateComponents([.weekday], from: Date()).weekday != 1 {
            VStack {
                HStack(spacing: -5) {
                    ForEach(weaponMaterialProvider.todaysMaterials, id: \.imageString) { material in
                        Image(material.imageString)
                            .resizable()
                            .scaledToFit()
//                            .padding(.horizontal, 3)
                    }
                }
                HStack(spacing: -5) {
                    ForEach(talentMaterialProvider.todaysMaterials, id: \.imageString) { material in
                        Image(material.imageString)
                            .resizable()
                            .scaledToFit()
//                            .padding(.horizontal, 3)
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}

//
//  PlanUserDefaultsModel.swift
//  LePla0418
//
//  Created by 吉川椛 on 2020/04/19.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

struct PlanUserDefaultsModel {
    
    // MARK: UserDefaults Key
    
    private let planStoredKey: String = "planStoredKey"
    
    // MARK: Memo
    
    func saveMemos(_ memo: [AddPlan]) {
        guard let data = try? JSONEncoder().encode(memo) else { return }
        UserDefaults.standard.set(data, forKey: planStoredKey)
    }
    
    func loadMemos() -> [AddPlan]? {
        guard let data = UserDefaults.standard.data(forKey: planStoredKey),
            let storedMemos = try? JSONDecoder().decode([AddPlan].self, from: data) else { return nil }
        return storedMemos
    }
}

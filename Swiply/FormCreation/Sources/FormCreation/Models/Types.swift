//
//  File.swift
//  
//
//  Created by Ksenia Petrova on 10.05.2024.
//

import Foundation

public enum Types {
    case name
    case town
    case info
    case education
    case work

    public var title: String {
        switch self {
            
        case .name:
            "Моё имя"
        case .town:
            "Мой город"
        case .info:
            "Моя биография"
        case .education:
            "Моё образование"
        case .work:
            "Моя работа"
        }
    }
    
    public var placeHolder: String {
        switch self {
            
        case .name:
            "Введите имя"
        case .town:
            "Укажи свой город"
        case .info:
            "Напиши немного о себе"
        case .education:
            "Институт, курсы ..."
        case .work:
            "Название компании, род деятельности ..."
        }
    }
    
    public var description: String {
        switch self {
            
        case .name:
            "Ваше имя будет отображаться в профиле Swiply, и у вас будет возможность его изменить"
        case .town:
            "Напиши свой город, чтобы знакомиться с людьми, которые живут рядом"
        case .info:
            "Напиши о себе, биография будет отображаться в твоём профиле"
        case .education:
            "Напиши о своём образование"
        case .work:
            "Напиши где тв работаешь или чем занимаешься"
        }
    }
}

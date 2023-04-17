//
//  LoggingService.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 14.03.2023.
//

import Amplitude

final class LoggingService {
    enum LoggingEvent {
        case diaryfirsttimeopened
        case diarywopen
        case diarywinclactive
        case diaryitemopen
        case diaryitemdelete
        case diaryaddfood
        case diaryscanfood
        case diaryfoodadded(count: Int)
        case diaryquickadd
        case diaryaddfromfoodscreen
        case diarysearch
        case diaryaddfromsearch
        case foundFoodByBarcode(isSuccessful: Bool)
        case diaryscanfromtabbar
        case diarybarcoderead(succeeded: Bool)
        case diaryscanfound(succeeded: Bool)
        case diarycreatefood
        case diarycreatefoodstep2
        case diarycreatefoodsave
        case diarycreatefoodadd
        case diarycustom
        case diarycustomadd
        case diarycreatemeal
        case diaryaddtomeal
        case diarymealsaved(count: Int)
        case diaryaddfooditem
        case diarycaloriegoal
        case calwopen
        case calchangedate
        case calcurrentdate
        case caldaysstreak(count: Int)
        case notewopen
        case noteaddtext
        case notesetmood
        case noteaddphoto
        case noteopennotes
        case notedelete
        case waterwopen
        case waterslider
        case waterquickbutton
        case watersetgoal(ml: Int)
        case watersetmeasure
        case watersetmanual
        case watertrack
        case watergoal
        case stepswopen
        case stepssetgoal
        case stepsgoal
        case weightwopen
        case weightsetgoal
        case weighttrack
        case recipesearch
        case recipeopenfromsearch
        case recipeaddtodiary
        case recipeaddfavorites
        case recipesetserving
        case obscreenXXIntdata
        case obAppleHealth
        case obAppleHealthwrite
        case obAppleHealthread
        
        var eventName: String {
            switch self {
            case .diarywopen:
                return "diary_w_open"
            case .diarywinclactive:
                return "diary_w_incl_active"
            case .diaryitemopen:
                return "diary_item_open"
            case .diaryitemdelete:
                return "diary_item_delete"
            case .diaryaddfood:
                return "diary_add_food"
            case .diaryscanfood:
                return "diary_scan_food"
            case .diaryfoodadded:
                return "diary_food_added"
            case .diaryquickadd:
                return "diary_quick_add"
            case .diaryaddfromfoodscreen:
                return "diary_add_from_food_screen"
            case .diarysearch:
                return "diary_search"
            case .diaryaddfromsearch:
                return "diary_add_from_search"
            case .diaryscanfromtabbar:
                return "diary_scan_from_tabbar"
            case .diarybarcoderead:
                return "diary_bar_code_read"
            case .diaryscanfound:
                return "diary_scan_found"
            case .diarycreatefood:
                return "diary_create_food"
            case .diarycreatefoodstep2:
                return "diary_create_food_step2"
            case .diarycreatefoodsave:
                return "diary_create_food_save"
            case .diarycreatefoodadd:
                return "diary_create_food_add"
            case .diarycustom:
                return "diary_custom"
            case .diarycustomadd:
                return "diary_custom_add"
            case .diarycreatemeal:
                return "diary_create_meal"
            case .diaryaddtomeal:
                return "diary_add_to_meal"
            case .diarymealsaved:
                return "diary_meal_saved"
            case .diaryaddfooditem:
                return "diary_add_food_item"
            case .diarycaloriegoal:
                return "diary_calorie_goal"
            case .calwopen:
                return "cal_w_open"
            case .calchangedate:
                return "cal_change_date"
            case .calcurrentdate:
                return "cal_current_date"
            case .caldaysstreak:
                return "cal_days_streak"
            case .notewopen:
                return "note_w_open"
            case .noteaddtext:
                return "note_add_text"
            case .notesetmood:
                return "note_set_mood"
            case .noteaddphoto:
                return "note_add_photo"
            case .noteopennotes:
                return "note_open_notes"
            case .notedelete:
                return "note_delete"
            case .waterwopen:
                return "water_w_open"
            case .waterslider:
                return "water_slider"
            case .waterquickbutton:
                return "water_quick_button"
            case .watersetgoal:
                return "water_set_goal"
            case .watersetmeasure:
                return "water_set_measure"
            case .watersetmanual:
                return "water_set_manual"
            case .watertrack:
                return "water_track"
            case .watergoal:
                return "water_goal"
            case .stepswopen:
                return "steps_w_open"
            case .stepssetgoal:
                return "steps_set_goal"
            case .stepsgoal:
                return "steps_goal"
            case .weightwopen:
                return "weight_w_open"
            case .weightsetgoal:
                return "weight_set_goal"
            case .weighttrack:
                return "weight_track"
            case .recipesearch:
                return "recipe_search"
            case .recipeopenfromsearch:
                return "recipe_open_from_search"
            case .recipeaddtodiary:
                return "recipe_add_to_diary"
            case .recipeaddfavorites:
                return "recipe_add_favorites"
            case .recipesetserving:
                return "recipe_set_serving"
            case .obscreenXXIntdata:
                return "ob_screen_XX_Int_data"
            case .obAppleHealth:
                return "ob_Apple_Health"
            case .obAppleHealthwrite:
                return "ob_Apple_Health_write"
            case .obAppleHealthread:
                return "ob_Apple Health_read"
            case .diaryfirsttimeopened:
                return "Diary_first_time_opened"
            case .foundFoodByBarcode(isSuccessful: let isSuccessful):
                return "Diary_barcode_found"
            }
        }
    }
    
    static func postEvent(event: LoggingEvent) {
        switch event {
        case .foundFoodByBarcode(isSuccessful: let isSuccessful):
            Amplitude.instance().logEvent(
                event.eventName, withEventProperties: ["isSuccessful": isSuccessful ? "Yes" : "No"]
            )
        case .diarybarcoderead(succeeded: let isSuccess):
            Amplitude.instance().logEvent(
                event.eventName, withEventProperties: ["scan_succeeded": isSuccess ? "Yes" : "No"]
            )
        case .diaryscanfound(succeeded: let isSuccess):
            Amplitude.instance().logEvent(
                event.eventName, withEventProperties: ["scan_found": isSuccess ? "Yes" : "No"]
            )
        case .diaryfoodadded(count: let count):
            Amplitude.instance().logEvent(
                event.eventName, withEventProperties: ["count": count]
            )
        case .diarymealsaved(count: let count):
            Amplitude.instance().logEvent(
                event.eventName, withEventProperties: ["count": count]
            )
        case .watersetgoal(ml: let ml):
            Amplitude.instance().logEvent(
                event.eventName, withEventProperties: ["mL": ml]
            )
        case .caldaysstreak(count: let streak):
            Amplitude.instance().logEvent(
                event.eventName, withEventProperties: ["streak": streak]
            )
        default:
            Amplitude.instance().logEvent(event.eventName)
        }
    }
}

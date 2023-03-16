//
//  RecomendationsViewModel.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 16.03.2023.
//

import Foundation

final class RecommendationsViewModel {
    
    // MARK: - Properties
    var onCellPressedCallback: ((String) -> Void)?
    
    private var recommendationsSections: [RecomendationsSectionModel] = []
    
    // MARK: - Init
    init() {
        createRecommendationsSections()
    }
    
    // MARK: - METHODS FOR TABLE
    func getSectionModel(at indexPath: IndexPath) -> RecomendationsSectionModel {
        recommendationsSections[indexPath.section]
    }
    
    func getLinkModel(at indexPath: IndexPath) -> RecommendationLink {
        recommendationsSections[indexPath.section].links[indexPath.row]
    }
    
    func getNumberOfSections() -> Int {
        recommendationsSections.count
    }
    
    func getNumberOfItemInSection(section: Int) -> Int {
        recommendationsSections[section].links.count
    }
    
    func getTitleForHeaderInSection(section: Int) -> String {
        recommendationsSections[section].section
    }
    
    func onTableCellPressed(section: Int, row: Int) {
        let urlString = recommendationsSections[section].links[row].link
        onCellPressedCallback?(urlString)
    }
    
    // swiftlint:disable function_body_length
    private func createRecommendationsSections() {
        recommendationsSections = [
            .init(
                section: R.string.localizable.recommendationsCalorieRecTitle(),
                links: [
                    .init(
                        text: R.string.localizable.recommendationsCalorieRecLinkText1(),
                        link: "https://www.nhlbi.nih.gov/files/docs/guidelines/ob_gdlns.pdf"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsCalorieRecLinkText2(),
                        link: "https://www.eatright.org/health/wellness/weight-and-body-positivity/healthy-weight-gain"
                    )
                ]
            ),
            .init(
                section: R.string.localizable.recommendationsDietsTitle(),
                links: []
            ),
            .init(
                section: R.string.localizable.recommendationsDietsClassicTitle(),
                links: [
                    .init(text: R.string.localizable.recommendationsDietsClassicLinkText1(),
                          link: "https://www.dietaryguidelines.gov/sites/default/files/2020-12/Dietary_Guidelines_for_Americans_2020-2025.pdf"),
                    .init(text: "https://www.who.int/news-room/fact-sheets/detail/healthy-diet",
                          link: "https://www.who.int/news-room/fact-sheets/detail/healthy-diet")
                ]),
            .init(
                section: R.string.localizable.recommendationsDietsCleaneatingTitle(),
                links: [
                    .init(text: R.string.localizable.recommendationsDietsCleaneatingLinkText1(),
                          link: "https://www.heart.org/en/healthy-living/healthy-eating/eat-smart/nutrition-basics/how-can-i-eat-more-nutrient-dense-foods"),
                    .init(text: R.string.localizable.recommendationsDietsCleaneatingLinkText2(),
                          link: "https://www.heart.org/en/healthy-living/healthy-eating/eat-smart/nutrition-basics/what-is-clean-eating"),
                    .init(text: R.string.localizable.recommendationsDietsCleaneatingText3(),
                          link: "https://www.heart.org/en/healthy-living/healthy-eating/eat-smart/nutrition-basics/protein-and-heart-health")
                ]),
            .init(
                section: R.string.localizable.recommendationsDietsMediterraneanTitle(),
                links: [
                    .init(
                        text: R.string.localizable.recommendationsDietsMediterraneanLinkText1(),
                        link: "https://www.heart.org/en/healthy-living/healthy-eating/eat-smart/nutrition-basics/mediterranean-diet"
                    )
                ]
            ),
            .init(
                section: R.string.localizable.recommendationsDietsScandinavianTitle(),
                links: [
                    .init(
                        text: R.string.localizable.recommendationsDietsScandinavianLinkText1(),
                        link: "https://pubmed.ncbi.nlm.nih.gov/20964740/"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsScandinavianLinkText2(),
                        link: "https://pubmed.ncbi.nlm.nih.gov/23398528/"
                    )
                ]
            ),
            .init(
                section: R.string.localizable.recommendationsDietsHighproteinTitle(),
                links: [
                    .init(
                        text: R.string.localizable.recommendationsDietsHighproteinLinkText1(),
                        link: "https://www.heart.org/en/healthy-living/healthy-eating/eat-smart/nutrition-basics/protein-and-heart-health"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsHighproteinLinkText2(),
                        link: "https://medlineplus.gov/ency/article/002467.htm"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsHighproteinLinkText3(),
                        link: "https://pubmed.ncbi.nlm.nih.gov/23097268/"
                    )
                ]
            ),
            .init(
                section: R.string.localizable.recommendationsDietsСlimatarianTitle(),
                links: [
                    .init(
                        text: R.string.localizable.recommendationsDietsСlimatarianLinkText1(),
                        link: "https://www.dietaryguidelines.gov/sites/default/files/2020-12/Dietary_Guidelines_for_Americans_2020-2025.pdf"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsСlimatarianLinkText2(),
                        link: "https://ec.europa.eu/environment/eussd/pdf/foodcycle_Final%20report_Dec%202012.pdf"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsСlimatarianLinkText3(),
                        link: "https://www.livsmedelsverket.se/matvanor-halsa--miljo/miljo/miljosmarta-matval2"
                    )
                ]
            ),
            .init(
                section: R.string.localizable.recommendationsDietsKetogenicTitle(),
                links: [
                    .init(
                        text: R.string.localizable.recommendationsDietsKetogenicLinkText1(),
                        link: "https://www.ncbi.nlm.nih.gov/books/NBK537084/"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsKetogenicLinkText2(),
                        link: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5959976/"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsKetogenicLinkText3(),
                        link: "https://www.cambridge.org/core/services/aop-cambridge-core/content/view/6FD9F975BAFF1D46F84C8BA9CE860783/S0007114513000548a.pdf/verylowcarbohydrate_ketogenic_diet_v_lowfat_diet_for_longterm_weight_loss_a_metaanalysis_of_randomised_controlled_trials.pdf"
                    )
                ]
            ),
            .init(
                section: R.string.localizable.recommendationsDietsKetogenicmediumTitle(),
                links: [
                    .init(
                        text: R.string.localizable.recommendationsDietsKetogenicLinkText1(),
                        link: "https://www.ncbi.nlm.nih.gov/books/NBK537084/"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsKetogenicLinkText2(),
                        link: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5959976/"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsKetogenicLinkText3(),
                        link: "https://www.cambridge.org/core/services/aop-cambridge-core/content/view/6FD9F975BAFF1D46F84C8BA9CE860783/S0007114513000548a.pdf/verylowcarbohydrate_ketogenic_diet_v_lowfat_diet_for_longterm_weight_loss_a_metaanalysis_of_randomised_controlled_trials.pdf"
                    )
                ]
            ),
            .init(
                section: R.string.localizable.recommendationsDietsKetogenicstrictTitle(),
                links: [
                    .init(
                        text: R.string.localizable.recommendationsDietsKetogenicLinkText1(),
                        link: "https://www.ncbi.nlm.nih.gov/books/NBK537084/"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsKetogenicLinkText2(),
                        link: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5959976/"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsKetogenicLinkText3(),
                        link: "https://www.cambridge.org/core/services/aop-cambridge-core/content/view/6FD9F975BAFF1D46F84C8BA9CE860783/S0007114513000548a.pdf/verylowcarbohydrate_ketogenic_diet_v_lowfat_diet_for_longterm_weight_loss_a_metaanalysis_of_randomised_controlled_trials.pdf"
                    )
                ]
            ),
            .init(
                section: R.string.localizable.recommendationsDietsFastingTitle(),
                links: [
                    .init(
                        text: R.string.localizable.recommendationsDietsFastingLinkText1(),
                        link: "https://www.nia.nih.gov/news/calorie-restriction-and-fasting-diets-what-do-we-know"
                    )
                ]
            ),
            .init(
                section: R.string.localizable.recommendationsDietsLifescoreTitle(),
                links: [
                    .init(
                        text: R.string.localizable.recommendationsDietsLifescoreLinkText1(),
                        link: "https://nap.nationalacademies.org/catalog/10925/dietary-reference-intakes-for-water-potassium-sodium-chloride-and-sulfate"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsLifescoreLinkText2(),
                        link: "https://www.myplate.gov/eathealthy/vegetables"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsLifescoreLinkText4(),
                        link: "https://www.fda.gov/food/consumers/advice-about-eating-fish"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsLifescoreLinkText5(),
                        link: "https://www.wcrf.org/diet-activity-and-cancer/cancer-prevention-recommendations/limit-red-and-processed-meat/"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsLifescoreLinkText6(),
                        link: "https://www.who.int/news-room/fact-sheets/detail/healthy-diet"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsLifescoreLinkText7(),
                        link: "https://www.who.int/teams/health-promotion/physical-activity/physical-activity-and-adults"
                    )
                ]
            ),
            .init(
                section: R.string.localizable.recommendationsDietsExerciseTitle(),
                links: [
                    .init(
                        text: R.string.localizable.recommendationsDietsExerciseLinkText1(),
                        link: "https://www.livsmedelsverket.se/en/food-habits-health-and-environment/dietary-guidelines/adults/physical-activity-advice"
                    ),
                    .init(
                        text: R.string.localizable.recommendationsDietsExerciseLinkText4(),
                        link: "https://sites.google.com/site/compendiumofphysicalactivities/Activity-Categories"
                    ),
                ]
            )
        ]
    }
}

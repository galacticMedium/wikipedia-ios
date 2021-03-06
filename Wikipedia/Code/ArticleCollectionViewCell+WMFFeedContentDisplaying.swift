import Foundation

public extension ArticleCollectionViewCell {
    @objc(configureWithArticle:displayType:index:theme:layoutOnly:)
    public func configure(article: WMFArticle, displayType: WMFFeedDisplayType, index: Int, theme: Theme, layoutOnly: Bool) {
        apply(theme: theme)
        
        let imageWidthToRequest = displayType.imageWidthCompatibleWithTraitCollection(traitCollection)
        if displayType != .mainPage, let imageURL = article.imageURL(forWidth: imageWidthToRequest) {
            isImageViewHidden = false
            if !layoutOnly {
                imageView.wmf_setImage(with: imageURL, detectFaces: true, onGPU: true, failure: { (error) in }, success: { })
            }
        } else {
            isImageViewHidden = true
        }
        
        let articleLanguage = article.url?.wmf_language
        
        titleHTML = article.displayTitleHTML
        
        switch displayType {
        case .random:
            imageViewDimension = 196
            isSaveButtonHidden = false
            descriptionLabel.text = article.capitalizedWikidataDescription
            extractLabel?.text = article.snippet
        case .pageWithPreview:
            imageViewDimension = 196
            isSaveButtonHidden = false
            descriptionLabel.text = article.capitalizedWikidataDescription
            extractLabel?.text = article.snippet
        case .continueReading:
            imageViewDimension = 150
            extractLabel?.text = nil
            isSaveButtonHidden = true
            descriptionLabel.text = article.capitalizedWikidataDescriptionOrSnippet
            extractLabel?.text = nil
        case .relatedPagesSourceArticle:
            setBackgroundColors(theme.colors.midBackground, selected: theme.colors.baseBackground)
            updateSelectedOrHighlighted()
            imageViewDimension = 150
            extractLabel?.text = nil
            isSaveButtonHidden = true
            descriptionLabel.text = article.capitalizedWikidataDescriptionOrSnippet
            extractLabel?.text = nil
        case .relatedPages:
            isSaveButtonHidden = false
            descriptionLabel.text = article.capitalizedWikidataDescriptionOrSnippet
            extractLabel?.text = nil
        case .mainPage:
            isSaveButtonHidden = true
            titleTextStyle = .georgiaTitle1
            descriptionTextStyle = .subheadline
            updateFonts(with: traitCollection)
            descriptionLabel.text = article.capitalizedWikidataDescription ?? WMFLocalizedString("explore-main-page-description", value: "Main page of Wikimedia projects", comment: "Main page description that shows when the main page lacks a Wikidata description.")
            extractLabel?.text = nil
        case .pageWithLocationPlaceholder:
            fallthrough
        case .pageWithLocation:
            isSaveButtonHidden = true
            isImageViewHidden = false
            descriptionLabel.text = article.capitalizedWikidataDescriptionOrSnippet
            extractLabel?.text = nil
            break
        case .compactList:
            configureForCompactList(at: index)
            fallthrough
        case .page:
            fallthrough
        default:
            imageViewDimension = 40
            isSaveButtonHidden = true
            descriptionLabel.text = article.capitalizedWikidataDescriptionOrSnippet
            extractLabel?.text = nil
        }
        
        titleLabel.accessibilityLanguage = articleLanguage
        descriptionLabel.accessibilityLanguage = articleLanguage
        extractLabel?.accessibilityLanguage = articleLanguage
        articleSemanticContentAttribute = MWLanguageInfo.semanticContentAttribute(forWMFLanguage: articleLanguage)
        setNeedsLayout()
    }
}

public extension ArticleRightAlignedImageCollectionViewCell {
    @objc public func configure(article: WMFArticle, displayType: WMFFeedDisplayType, index: Int, shouldShowSeparators: Bool = false, theme: Theme, layoutOnly: Bool) {
        if shouldShowSeparators {
            self.topSeparator.isHidden = index != 0
            self.bottomSeparator.isHidden = false
        } else {
            self.bottomSeparator.isHidden = true
        }
        super.configure(article: article, displayType: displayType, index: index, theme: theme, layoutOnly: layoutOnly)
    }
}

public extension RankedArticleCollectionViewCell {
    public override func configure(article: WMFArticle, displayType: WMFFeedDisplayType, index: Int, shouldShowSeparators: Bool = false, theme: Theme, layoutOnly: Bool) {
        rankView.rank = index + 1
        let percent = CGFloat(index + 1) / CGFloat(5)
        rankView.tintColor = theme.colors.linkToAccent.color(at: percent)
        super.configure(article: article, displayType: displayType, index: index, shouldShowSeparators: shouldShowSeparators, theme: theme, layoutOnly: layoutOnly)
    }
    
    public override func configure(article: WMFArticle, displayType: WMFFeedDisplayType, index: Int, theme: Theme, layoutOnly: Bool) {
        configure(article: article, displayType: displayType, index: index, shouldShowSeparators: false, theme: theme, layoutOnly: layoutOnly)
    }
}

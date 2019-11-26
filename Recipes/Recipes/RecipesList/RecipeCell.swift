//
//  RecipeCell.swift
//  Recipes
//
//  Created by Hugo Alonso on 26/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class RecipeCell: UITableViewCell {

    private lazy var titleLabel: UILabel = self.createTitleLabel()
    private lazy var ingredients: UILabel = self.createIngredientsLabel()
    private lazy var hasLactose: UILabel = self.hasLactoseLabel()
    private lazy var recipeImage: UIImageView = self.createRecipeImageView()
    private lazy var makeFavorite: UIButton = self.createMakeFavoriteButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .lightGray
        selectionStyle = .none

        addSubview(recipeImage)
        addSubview(makeFavorite)
        addSubview(titleLabel)
        addSubview(ingredients)
        addSubview(hasLactose)

        recipeImage.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview()
            make.height.equalTo(250)
        }

        makeFavorite.snp.makeConstraints { make in
            make.top.equalTo(recipeImage.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(8)
            make.width.equalTo(120)
            make.height.equalTo(50)
            make.bottom.greaterThanOrEqualToSuperview().offset(8).priority(.low)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeImage.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
            make.height.greaterThanOrEqualTo(44)
            make.right.equalTo(makeFavorite.snp.left)
        }

        ingredients.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.height.greaterThanOrEqualTo(44)
            make.bottom.equalToSuperview().inset(8)
        }

        hasLactose.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(60)
            make.height.equalTo(44)
            make.width.equalTo(200)
        }

        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }

    func setIngredients(_ ingredients: String) {
        self.ingredients.text = ingredients
    }

    func setFavorited(_ favorited: Bool) {
        let text = favorited ? "Remove favorite" : "Make favorite"
        makeFavorite.setTitle(text, for: .normal)
    }

    func setHasLactose(_ hasLactose: Bool) {
        self.hasLactose.isHidden = !hasLactose
    }

    func setImage(_ image: URL?) {
        self.recipeImage.kf.indicatorType = .activity
        DispatchQueue.main.async {
            self.recipeImage.kf.setImage(
                with: image,
                placeholder: UIImage(named:"No Image"),
                options: [.transition(ImageTransition.fade(1))]
            )
        }
    }
}

// MARK: Initialisers
extension RecipeCell {
    private func createRecipeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.accessibilityIdentifier = "recipeImage"
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        return imageView
    }

    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        label.accessibilityIdentifier = "title"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }

    private func createIngredientsLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        label.accessibilityIdentifier = "ingredients"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }

    private func hasLactoseLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        label.alpha = 0.8
        label.textAlignment = .center
        label.text = "Has Lactose"
        label.accessibilityIdentifier = "lactose"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1

        let radians = CGFloat.pi * CGFloat(45) / CGFloat(180.0)
        label.transform = CGAffineTransform(rotationAngle: radians)
        return label
    }

    private func createMakeFavoriteButton() -> UIButton {
        let favorite = UIButton()
        return favorite
    }
}

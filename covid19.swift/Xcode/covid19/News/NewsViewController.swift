//
//  NewsViewController.swift
//  covid19
//
//  Created by Daniel on 3/30/20.
//  Copyright © 2020 dk. All rights reserved.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController {
    // UI
    private var collectionView: UICollectionView?
    private let refreshControl = UIRefreshControl()

    // Data
    private let apiKey = "8815d577462a4195a64f6f50af3ada08"
    private var articles: [Article] = []
    private var imageCache: [String: UIImage] = [:]

    init(tab: Tab) {
        super.init(nibName: nil, bundle:nil)

        title = tab.name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        configure()
        loadData()
    }
}

private extension NewsViewController {
    func setup() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView?.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        collectionView?.backgroundColor = .white

        collectionView?.dataSource = self
        collectionView?.delegate = self

        refreshControl.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
    }

    func configure() {
        // Collection view
        collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        if let cv = collectionView {
            view.addSubview(cv)
        }

        // Refresh control
        collectionView?.addSubview(refreshControl)
    }

    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let inset: CGFloat = 15
        let sideInset: CGFloat = 30
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: sideInset, bottom: 0, trailing: sideInset)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(280))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: sideInset, trailing: 0)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    @objc func loadData() {
        guard let url = URL.init(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)&category=health") else {
            self.presentOkAlertWithMessage("Error with the News API URL")
            return
        }

        self.articles = []
        self.collectionView?.reloadData()

        url.get(type: Headline.self) { (result) in
            self.refreshControl.endRefreshing()

            switch result {
            case .success(let headline):
                self.articles = headline.articles

                self.collectionView?.reloadData()

            case .failure(let e):
                self.presentOkAlertWithMessage(e.localizedDescription)
            }
        }
    }
}
extension NewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let article = self.articles[indexPath.row]

        let c = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as! NewsCell

        c.label.attributedText = article.attributedContent
        c.dateLabel.attributedText = article.attributedDate
        c.sourceLabel.attributedText = article.attributedSource
        getImage(article.urlToImage) { (image) in
            c.imageView.image = image
        }

        return c
    }

    private func getImage(_ imageUrl: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = imageUrl else {
            completion(nil)
            return
        }

        if let image = imageCache[url.absoluteString] {
            completion(image)
        }
        else {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async { [weak self] in
                        let image = UIImage(data: data)
                        self?.imageCache[url.absoluteString] = image
                        completion(image)
                    }
                }
            }
        }
    }
}

extension NewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let article = articles[indexPath.row]

        guard let url = article.url else {
            return
        }

        let sfvc = SFSafariViewController.init(url: url)
        self.present(sfvc, animated: true, completion: nil)
    }
}

private extension Article {
    var attributedDate: NSAttributedString {
        guard let publishedAt = self.publishedAt else {
            return NSAttributedString()
        }

        let f = ISO8601DateFormatter()
        let da = f.date(from: publishedAt)
        guard let date = da else {
            return NSAttributedString()
        }

        let attribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.gray
        ]

        return NSAttributedString(string: "\(date.timeAgoSinceDate())", attributes: attribute)
    }

    var attributedSource: NSAttributedString {
        guard let source = self.source,
            let name = source.name else {
                return NSAttributedString()
        }

        let attribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.gray
        ]

        return NSAttributedString(string: "\(name)", attributes: attribute)
    }

    var attributedContent: NSAttributedString {
        let titleAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]
        let a = NSMutableAttributedString.init(string: "\(title ?? "")\n", attributes: titleAttribute)

        let whiteColorAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.white
        ]
        let b =  NSAttributedString.init(string: description ?? content ?? "", attributes: whiteColorAttribute)
        a.append(b)

        return a
    }
}

// Credits: https://stackoverflow.com/questions/34457434/swift-convert-time-to-time-ago
private extension Date {
    func timeAgoSinceDate() -> String {
        // From Time
        let fromDate = self

        // To Time
        let toDate = Date()

        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }

        return "a moment ago"
    }
}

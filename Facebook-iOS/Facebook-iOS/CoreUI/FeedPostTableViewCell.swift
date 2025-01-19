//
//  FeedPostTableViewCell.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 05.02.2024.
//

import UIKit

class FeedPostTableViewCell: UITableViewCell, UITextViewDelegate {

    public static var reuseIdentifier: String { return String(describing: self) }

    private var dataSource: UICollectionViewDiffableDataSource<FeedView.Section, Image>!

    private var feedImages: [Image]?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        setupLayout()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var cellView: UIView = {
        let localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    private lazy var userProfilePhoto: UIImageView = {
        let localImage = UIImageView()
        localImage.translatesAutoresizingMaskIntoConstraints = false
        localImage.layer.masksToBounds = true
        localImage.layer.cornerRadius = 10
        return localImage
    }()
    
    private lazy var nameAndDateView: UIView = {
        let localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.addSubview(nameLabel)
        localView.addSubview(dateLabel)
        return localView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .black
        label.font = .robotoBoldItalic(size: 14)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .lightGray
        label.font = .robotoRegular(size: 11)
        return label
    }()
    
    private lazy var postContainer: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textCommentView, feedImageCollectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var feedImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let localView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.isPagingEnabled = true
        localView.delegate = self
        localView.dataSource = dataSource
        localView.register(FeedPostCollectionViewCell.self, forCellWithReuseIdentifier: FeedPostCollectionViewCell.reuseIdentifier)
        return localView
    }()

    private var feedImageViewHeightConstraint: NSLayoutConstraint?

    private lazy var textCommentView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.sizeToFit()
        textView.delegate = self
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = .robotoRegular(size: 12)
        textView.textContainer.maximumNumberOfLines = 0
        return textView
    }()

    private lazy var actionsView: UIStackView = {
        let localView = UIStackView(arrangedSubviews: [shareIconImage, heartIconImage])
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.axis = .horizontal
        localView.distribution = .fill
        localView.alignment = .center
        localView.spacing = Constants.innerOffset
        localView.layoutIfNeeded()
        return localView
    }()

    private lazy var heartIconImage: UIImageView = {
        let localView = UIImageView()
        localView.image = UIImage(named: "heart_icon")
        return localView
    }()

    private lazy var shareIconImage: UIImageView = {
        let localView = UIImageView()
        localView.image = UIImage(named: "share_icon")
        localView.contentMode = .center
        return localView
    }()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm, MMM d, y"
        return formatter
    }()

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: feedImageCollectionView,
                                                        cellProvider: { feedImageCollectionView, indexPath, image -> UICollectionViewCell? in

            guard let cell = feedImageCollectionView.dequeueReusableCell(withReuseIdentifier: FeedPostCollectionViewCell.reuseIdentifier, 
                                                                         for: indexPath) as? FeedPostCollectionViewCell else { return UICollectionViewCell() }

            if let images = self.feedImages, let item = images[safe: indexPath.row] {
                cell.setupCell(image: item)
            }

            return cell
        })
    }

    private func updateDataSource() {
        if let images = feedImages {
            var snapshot = NSDiffableDataSourceSnapshot<FeedView.Section, Image>()
            snapshot.appendSections([.main])
            snapshot.appendItems(images)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    private func setupLayout() {

        contentView.addSubview(cellView)

        cellView.addSubview(userProfilePhoto)
        cellView.addSubview(nameAndDateView)
        cellView.addSubview(postContainer)
        cellView.addSubview(actionsView)

        feedImageViewHeightConstraint = NSLayoutConstraint(item: feedImageCollectionView, 
                                                           attribute: .height,
                                                           relatedBy: .equal,
                                                           toItem: nil,
                                                           attribute: .notAnAttribute, 
                                                           multiplier: 1,
                                                           constant: Constants.defaultImageHeight)
        feedImageViewHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            cellView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.innerOffset),

            userProfilePhoto.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: Constants.leadingOffset),
            userProfilePhoto.topAnchor.constraint(equalTo: cellView.topAnchor, constant: Constants.innerOffset),
            userProfilePhoto.heightAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: Constants.profileSizeMultiplier),
            userProfilePhoto.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: Constants.profileSizeMultiplier),

            nameAndDateView.leftAnchor.constraint(equalTo: userProfilePhoto.rightAnchor, constant: Constants.innerOffset),
            nameAndDateView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: Constants.innerOffset),
            nameAndDateView.heightAnchor.constraint(equalTo: userProfilePhoto.heightAnchor),
            nameAndDateView.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: 0.5),

            nameLabel.leftAnchor.constraint(equalTo: nameAndDateView.leftAnchor),
            nameLabel.topAnchor.constraint(equalTo: nameAndDateView.topAnchor),
            nameLabel.heightAnchor.constraint(equalTo: nameAndDateView.heightAnchor, multiplier: 0.66),
            nameLabel.widthAnchor.constraint(equalTo: nameAndDateView.widthAnchor),
            
            dateLabel.leftAnchor.constraint(equalTo: nameAndDateView.leftAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: nameAndDateView.bottomAnchor),
            dateLabel.heightAnchor.constraint(equalTo: nameAndDateView.heightAnchor, multiplier: 0.34),
            dateLabel.widthAnchor.constraint(equalTo: nameAndDateView.widthAnchor),
            
            postContainer.leftAnchor.constraint(equalTo: cellView.leftAnchor),
            postContainer.topAnchor.constraint(equalTo: userProfilePhoto.bottomAnchor, constant: Constants.leadingOffset),
            postContainer.rightAnchor.constraint(equalTo: cellView.rightAnchor),

            textCommentView.leftAnchor.constraint(equalTo: postContainer.leftAnchor, constant: Constants.leadingOffset),
            textCommentView.topAnchor.constraint(equalTo: postContainer.topAnchor),
            textCommentView.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -Constants.leadingOffset),
            textCommentView.bottomAnchor.constraint(equalTo: feedImageCollectionView.topAnchor),
            textCommentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),

            feedImageCollectionView.leftAnchor.constraint(equalTo: postContainer.leftAnchor),
            feedImageCollectionView.topAnchor.constraint(equalTo: textCommentView.bottomAnchor),
            feedImageCollectionView.rightAnchor.constraint(equalTo: postContainer.rightAnchor),
            feedImageCollectionView.bottomAnchor.constraint(equalTo: postContainer.bottomAnchor),
            feedImageCollectionView.widthAnchor.constraint(equalTo: postContainer.widthAnchor),

            actionsView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: Constants.leadingOffset),
            actionsView.topAnchor.constraint(equalTo: postContainer.bottomAnchor, constant: Constants.innerOffset / 2),
            actionsView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor)
        ])
    }

    public func configurePostCell(with feed: FeedPostTableViewCellModel) {
        userProfilePhoto.downloadImage(from: feed.profileUrl) {
            self.userProfilePhoto.image = UIImage(named: PhotoType.profile.defaultImage)
        }

        nameLabel.text = feed.firstAndLastName
        dateLabel.text = convertDateToString(date: feed.date)
        showTextViewIfNeeded(for: feed)
        showImageCollectionViewIfNeeded(for: feed)

        updateDataSource()
    }

    private func convertDateToString(date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    private func showTextViewIfNeeded(for feed: FeedPostTableViewCellModel) {
        guard let message = feed.message else {
            if let images = feed.images, !images.isEmpty {
                textCommentView.isHidden = true
            } else {
                textCommentView.text = feed.title
            }

            return
        }

        textCommentView.text = message
    }

    private func showImageCollectionViewIfNeeded(for feed: FeedPostTableViewCellModel) {
        if let images = feed.images, !images.isEmpty {
            feedImages = images
            feedImageViewHeightConstraint?.constant = calculateHeightOfImageCollectionView(images: images)
        } else {
            feedImageViewHeightConstraint?.constant = Constants.minHeight
        }
    }

    private func calculateHeightOfImageCollectionView(images: [Image]?) -> CGFloat {
        guard let images = images else { return Constants.defaultImageHeight }

        var height: CGFloat = CGFloat.greatestFiniteMagnitude

        for image in images {
            let ratio = frame.width / CGFloat(image.width)
            let newHeight = CGFloat(image.height) * ratio

            if newHeight < height {
                height = newHeight
            }
        }
        
        return height
    }

    private struct Constants {
        static let leadingOffset: CGFloat = 21
        static let innerOffset: CGFloat = 15
        static let profileSizeMultiplier: CGFloat = 0.15
        static let minHeight: CGFloat = 0
        static let defaultImageHeight: CGFloat = 210.0
    }
    
}

extension FeedPostTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: feedImageCollectionView.frame.width,
                      height: calculateHeightOfImageCollectionView(images: feedImages))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        userProfilePhoto.image = nil
        nameLabel.text = nil
        dateLabel.text = nil
        textCommentView.text = nil
        textCommentView.isHidden = false
    }
}

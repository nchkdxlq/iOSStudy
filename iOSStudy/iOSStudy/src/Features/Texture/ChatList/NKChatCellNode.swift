//
//  NKChatCellNode.swift
//  iOSStudy
//
//  Created by Knox on 2021/12/9.
//
import AsyncDisplayKit

class NKChatCellNode: ASCellNode {
    
    let avatarNode: ASImageNode = {
        let node = ASImageNode()
        node.isLayerBacked = true
        return node
    }()
    
    let nameNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        node.isLayerBacked = true
        return node
    }()
    
    let timeNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        node.isLayerBacked = true
        return node
    }()
    
    let descNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        node.truncationMode = .byTruncatingTail
        node.isLayerBacked = true
        return node
    }()
    
    let slientNode: ASImageNode = {
        let node = ASImageNode()
        node.isLayerBacked = true
        node.image = UIImage(named: "chat_slient")
        return node
    }()
    
    let chat: NKChat
    
    @objc init(chat: NKChat) {
        self.chat = chat
        super.init()
        selectionStyle = .none
        
        addSubnode(avatarNode)
        addSubnode(nameNode)
        addSubnode(descNode)
        addSubnode(timeNode)
        addSubnode(slientNode)
        
        avatarNode.image = UIImage(named: chat.avatar)
        nameNode.attributedText = NSAttributedString(string: chat.name, attributes: nameTextStyle())
        descNode.attributedText = NSAttributedString(string: chat.desc, attributes: descTextStyle())
        timeNode.attributedText = NSAttributedString(string: chat.updateTime.description, attributes: timeTextStyle())
    }
    
    private func nameTextStyle() -> [NSAttributedString.Key:Any] {
        return [.font:UIFont.systemFont(ofSize: 16), .foregroundColor:UIColor.black];
    }
    
    
    private func descTextStyle() -> [NSAttributedString.Key:Any] {
        return [.font:UIFont.systemFont(ofSize: 14), .foregroundColor:UIColor.lightGray];
    }
    
    private func timeTextStyle() -> [NSAttributedString.Key:Any] {
        return [.font:UIFont.systemFont(ofSize: 12), .foregroundColor:UIColor.lightGray];
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avatarNode.style.preferredSize = CGSize(width: 48, height: 48)
        // 在 main axis 方向上, 内容的宽度大于最大宽度，被压缩的比例
        nameNode.style.flexShrink = 1.0
        let nameTimeStack = ASStackLayoutSpec(direction: .horizontal,
                                              spacing: 4,
                                              justifyContent: .spaceBetween,
                                              alignItems: .start,
                                              children: [nameNode, timeNode])
        
        descNode.style.flexShrink = 1.0
        slientNode.style.preferredSize = CGSize(width: 20, height: 20);
        let descSlientStack = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: 4,
                                                justifyContent: .spaceBetween,
                                                alignItems: .center,
                                                children: [descNode, slientNode])

        let contentStack = ASStackLayoutSpec(direction: .vertical,
                                             spacing: 10,
                                             justifyContent: .center,
                                             alignItems: .stretch,
                                             children: [nameTimeStack, descSlientStack])
        
        // 在 main axis 方向, 内容的空间小于最大宽度时, 即main axis方法还有空间剩余, 当前node的拉伸占剩余空间的比例
        contentStack.style.flexGrow = 1.0
        contentStack.style.flexShrink = 1.0
        let avatarContentStack = ASStackLayoutSpec(direction: .horizontal,
                                                   spacing: 10,
                                                   justifyContent: .start,
                                                   alignItems: .center,
                                                   children: [avatarNode, contentStack])
        
        let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return ASInsetLayoutSpec(insets: insets, child: avatarContentStack)
    }
}


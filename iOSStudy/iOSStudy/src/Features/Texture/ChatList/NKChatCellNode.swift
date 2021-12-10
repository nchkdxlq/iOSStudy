//
//  NKChatCellNode.swift
//  iOSStudy
//
//  Created by Knox on 2021/12/9.
//
import AsyncDisplayKit

class NKChatCellNode: ASCellNode {
    
    let avatarNode = ASImageNode()
    let nameNode = ASTextNode()
    let timeNode = ASTextNode()
    let descNode = ASTextNode()
    
    let chat: NKChat
    
    @objc init(chat: NKChat) {
        self.chat = chat
        super.init()
        selectionStyle = .none
        
        addSubnode(avatarNode)
        addSubnode(nameNode)
        addSubnode(descNode)
        addSubnode(timeNode)
        
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
        
        let nameTimeStack = ASStackLayoutSpec(direction: .horizontal,
                                              spacing: 10,
                                              justifyContent: .spaceBetween,
                                              alignItems: .start,
                                              children: [nameNode, timeNode])
        // 在cross axis 的对齐方式
        nameTimeStack.style.alignSelf = .stretch
        
        let nameDescStack = ASStackLayoutSpec(direction: .vertical,
                                              spacing: 10,
                                              justifyContent: .center,
                                              alignItems: .start,
                                              children: [nameTimeStack, descNode])
        // 在 main cross 方向, 内容的空间小于最大宽度时, 即main cross方法还有空间剩余, 当前node的拉伸占剩余空间的比例
        nameDescStack.style.flexGrow = 1.0
        
        let avatarContentStack = ASStackLayoutSpec(direction: .horizontal,
                                                   spacing: 10,
                                                   justifyContent: .start,
                                                   alignItems: .center,
                                                   children: [avatarNode, nameDescStack])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: avatarContentStack)
    }
}


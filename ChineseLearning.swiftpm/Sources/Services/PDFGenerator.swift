import UIKit

actor PDFGenerator {

    struct PageConfig {
        var pageWidth: CGFloat = 595    // A4 width in points
        var pageHeight: CGFloat = 842   // A4 height in points
        var margin: CGFloat = 40
        var gridCellSize: CGFloat = 50
        var gridColumns: Int = 8
    }

    func generate(cards: [VocabularyCard], config: PageConfig = PageConfig()) -> Data? {
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: config.pageWidth, height: config.pageHeight))

        let data = renderer.pdfData { context in
            for card in cards {
                context.beginPage()
                drawPage(card: card, context: context.cgContext, config: config)
            }
        }

        return data
    }

    private func drawPage(card: VocabularyCard, context: CGContext, config: PageConfig) {
        var currentY: CGFloat = config.margin
        currentY = drawReferenceSection(card: card, context: context, config: config, startY: currentY)
        currentY += 20
        currentY = drawWritingGrid(context: context, config: config, startY: currentY)
        currentY += 24
        drawExampleSection(card: card, context: context, config: config, startY: currentY)
    }

    private func drawReferenceSection(
        card: VocabularyCard,
        context: CGContext,
        config: PageConfig,
        startY: CGFloat
    ) -> CGFloat {
        let margin = config.margin
        let pageWidth = config.pageWidth
        let contentWidth = pageWidth - margin * 2
        var y = startY

        let bgRect = CGRect(x: margin, y: y, width: contentWidth, height: 220)
        context.setFillColor(UIColor.systemGray6.cgColor)
        let bgPath = UIBezierPath(roundedRect: bgRect, cornerRadius: 12)
        bgPath.fill()
        y += 20

        let wordAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 64, weight: .light),
            .foregroundColor: UIColor.label
        ]
        NSAttributedString(string: card.word, attributes: wordAttrs).draw(at: CGPoint(x: margin + 16, y: y))
        y += 76

        let pinyinAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.italicSystemFont(ofSize: 18),
            .foregroundColor: UIColor.secondaryLabel
        ]
        NSAttributedString(string: card.pinyin, attributes: pinyinAttrs).draw(at: CGPoint(x: margin + 16, y: y))
        y += 28

        let meaningAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 22, weight: .semibold),
            .foregroundColor: UIColor.label
        ]
        NSAttributedString(string: card.meaning, attributes: meaningAttrs).draw(at: CGPoint(x: margin + 16, y: y))
        y += 34

        context.setStrokeColor(UIColor.separator.cgColor)
        context.setLineWidth(0.5)
        context.move(to: CGPoint(x: margin + 16, y: y))
        context.addLine(to: CGPoint(x: pageWidth - margin - 16, y: y))
        context.strokePath()
        y += 10

        if !card.exampleSentence.isEmpty {
            let exAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.label
            ]
            NSAttributedString(string: card.exampleSentence, attributes: exAttrs)
                .draw(in: CGRect(x: margin + 16, y: y, width: contentWidth - 32, height: 22))
            y += 22

            let transAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.secondaryLabel
            ]
            NSAttributedString(string: card.exampleTranslation, attributes: transAttrs)
                .draw(in: CGRect(x: margin + 16, y: y, width: contentWidth - 32, height: 20))
        }

        return startY + 230
    }

    private func drawWritingGrid(
        context: CGContext,
        config: PageConfig,
        startY: CGFloat
    ) -> CGFloat {
        let margin = config.margin
        let cellSize = config.gridCellSize
        let cols = config.gridColumns
        let rows = 2
        var y = startY

        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .medium),
            .foregroundColor: UIColor.secondaryLabel
        ]
        NSAttributedString(string: "漢字練習", attributes: labelAttrs).draw(at: CGPoint(x: margin, y: y))
        y += 18

        let guideColor = UIColor.systemGray4.withAlphaComponent(0.5).cgColor

        for row in 0..<rows {
            for col in 0..<cols {
                let cellX = margin + CGFloat(col) * cellSize
                let cellY = y + CGFloat(row) * cellSize

                context.setStrokeColor(UIColor.systemGray3.cgColor)
                context.setLineWidth(0.8)
                context.stroke(CGRect(x: cellX, y: cellY, width: cellSize, height: cellSize))

                context.setStrokeColor(guideColor)
                context.setLineWidth(0.3)
                context.move(to: CGPoint(x: cellX, y: cellY + cellSize / 2))
                context.addLine(to: CGPoint(x: cellX + cellSize, y: cellY + cellSize / 2))
                context.move(to: CGPoint(x: cellX + cellSize / 2, y: cellY))
                context.addLine(to: CGPoint(x: cellX + cellSize / 2, y: cellY + cellSize))
                context.strokePath()
            }
        }

        return y + CGFloat(rows) * cellSize
    }

    private func drawExampleSection(
        card: VocabularyCard,
        context: CGContext,
        config: PageConfig,
        startY: CGFloat
    ) {
        let margin = config.margin
        let contentWidth = config.pageWidth - margin * 2
        var y = startY

        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .medium),
            .foregroundColor: UIColor.secondaryLabel
        ]
        NSAttributedString(string: "例文練習（意味を見て例文を書いてください）", attributes: labelAttrs)
            .draw(at: CGPoint(x: margin, y: y))
        y += 20

        if !card.exampleTranslation.isEmpty {
            let promptAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.secondaryLabel
            ]
            NSAttributedString(string: "「\(card.exampleTranslation)」", attributes: promptAttrs)
                .draw(at: CGPoint(x: margin, y: y))
            y += 22
        }

        context.setStrokeColor(UIColor.systemGray4.cgColor)
        context.setLineWidth(0.5)
        for i in 0..<4 {
            let lineY = y + CGFloat(i) * 32 + 28
            context.move(to: CGPoint(x: margin, y: lineY))
            context.addLine(to: CGPoint(x: margin + contentWidth, y: lineY))
            context.strokePath()
        }
    }
}

import SwiftUI

public struct RangedSliderView: View {
    let currentValue: Binding<ClosedRange<CGFloat>>
    let sliderBounds: ClosedRange<Int>

    public init(value: Binding<ClosedRange<CGFloat>>, bounds: ClosedRange<Int>) {
        self.currentValue = value
        self.sliderBounds = bounds
    }

    public var body: some View {
        GeometryReader { geomentry in
            sliderView(sliderSize: geomentry.size)
        }
    }


    @ViewBuilder private func sliderView(sliderSize: CGSize) -> some View {
        let sliderViewYCenter = sliderSize.height / 2
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(.gray)
                .brightness(0.3)
                .frame(height: 4)
            ZStack {
                let sliderBoundDifference = sliderBounds.count - 1
                let stepWidthInPixel = CGFloat(sliderSize.width) / CGFloat(sliderBoundDifference)

                // Calculate Left Thumb initial position
                let leftThumbLocation: CGFloat = currentValue.wrappedValue.lowerBound == CGFloat(sliderBounds.lowerBound)
                    ? 0
                    : CGFloat(currentValue.wrappedValue.lowerBound - CGFloat(sliderBounds.lowerBound)) * stepWidthInPixel

                // Calculate right thumb initial position
                let rightThumbLocation = CGFloat(currentValue.wrappedValue.upperBound) * stepWidthInPixel

                // Path between both handles
                lineBetweenThumbs(from: .init(x: leftThumbLocation, y: sliderViewYCenter), to: .init(x: rightThumbLocation, y: sliderViewYCenter))

                // Left Thumb Handle
                let leftThumbPoint = CGPoint(x: leftThumbLocation, y: sliderViewYCenter)
                thumbView(position: leftThumbPoint, value: currentValue.wrappedValue.lowerBound)
                    .highPriorityGesture(DragGesture().onChanged { dragValue in

                        let dragLocation = dragValue.location
                        let xThumbOffset = min(max(0, dragLocation.x), sliderSize.width)

                        let newValue = CGFloat(sliderBounds.lowerBound) + xThumbOffset / stepWidthInPixel

                        // Stop the range thumbs from colliding each other
                        if newValue < CGFloat(currentValue.wrappedValue.upperBound) {
                            currentValue.wrappedValue = newValue...currentValue.wrappedValue.upperBound
                        }
                    })

                // Right Thumb Handle
                thumbView(position: CGPoint(x: rightThumbLocation, y: sliderViewYCenter), value: currentValue.wrappedValue.upperBound)
                    .highPriorityGesture(DragGesture().onChanged { dragValue in
                        let dragLocation = dragValue.location
                        let xThumbOffset = min(max(CGFloat(leftThumbLocation), dragLocation.x), sliderSize.width)

                        var newValue = Int(xThumbOffset / stepWidthInPixel) // convert back the value bound
                        newValue = min(newValue, sliderBounds.upperBound)

                        // Stop the range thumbs from colliding each other
                        if CGFloat(newValue) > currentValue.wrappedValue.lowerBound {
                            currentValue.wrappedValue = currentValue.wrappedValue.lowerBound...CGFloat(newValue)
                        }
                    })
            }
        }
    }

    @ViewBuilder func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }.stroke(.pink, lineWidth: 4)
    }

    @ViewBuilder func thumbView(position: CGPoint, value: CGFloat) -> some View {
        ZStack {
//            Text(String(value))
//                .font(.caption)
//                .offset(y: -20)
            Circle()
                .frame(width: 28, height: 28)
                .foregroundColor(.pink)
                .shadow(color: Color.black.opacity(0.16), radius: 8, x: 0, y: 2)
                .contentShape(Rectangle())
        }
        .position(x: position.x, y: position.y)
    }
}

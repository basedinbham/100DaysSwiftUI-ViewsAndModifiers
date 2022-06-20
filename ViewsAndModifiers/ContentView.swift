//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Kyle Warren on 6/18/22.
//

import SwiftUI

struct ProminentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func prominentTitle() -> some View {
        modifier(ProminentTitle())
    }
}

struct Watermark: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(.black)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct CapsuleText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .background(.blue)
            .clipShape(Capsule())
    }
}

// When working with custom modifiers, it’s usually a smart idea to create extensions on View that make them easier to use. For example, we might wrap the Title modifier in an extension such as this
extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    var body: some View {
        Color.blue
            .frame(width: 300, height: 200)
            .watermarked(with: "Hacking With Swift")
        
        Text("Hello, world!")
            // modifier can now be used in this manner due to extension on View
            // modifiers return new objects rather than modifying existing ones
            .titleStyle()
    }
    
    var body1: some View {
        VStack(spacing: 10) {
            CapsuleText(text: "First")
                .foregroundColor(.white)
            CapsuleText(text: "Second")
                .foregroundColor(.yellow)
        }
    }
    
    
    // unlike the body property, Swift won’t automatically apply the @ViewBuilder attribute here, so if you want to send multiple views back you have three options.
    var motto1: some View {
        Text("Draco dormiens")
    }
    let motto2 = Text("nunquam titillandus")
    
    // Option 1
    var spells: some View {
        VStack {
            Text("Lumos")
            Text("Obliviate")
        }
    }
    // Option 2 - if you don’t specifically want to organize them in a stack, you can also send back a Group. When this happens,
    // the arrangement of your views is determined by how you use them elsewhere in your code:
    var spells1: some View {
        Group {
            Text("Lumos")
            Text("Obliviate")
        }
    }
    // Option 3 - @ViewBuilder mimics the way body works (preferred by Paul Hudson) they are wary when they see folks cram lots of functionality into their properties – it’s usually a sign that their views are getting a bit too complex, and need to be broken up.
    @ViewBuilder var spells2: some View {
        Text("Lumos")
        Text("Obliviate")
    }
    
    var body2: some View {
        VStack {
            motto1
                .foregroundColor(.red)
            motto2
                .foregroundColor(.blue)
        }
    }
    
    var body3: some View {
        VStack {
            Text("Gryf")
            // Child modifier takes priority over parent modifier
                .font(.largeTitle)
            // regular modifier so this is being added to the parent as well (cannot replace parent)
                .blur(radius: 0)
            Text("Huff")
            Text("Rave")
            Text("Slyth")
        }
        // apply modifier to VStack rather than individual text (Environment modifier)
        .font(.title)
        // .blur is a regular modifier, so any blurs applied to child views are added to the VStack blur rather than replacing
        .blur(radius: 5)
    }
    
    var body4: some View {
        Button("Hello, world!") {
            useRedText.toggle()
        }
        .foregroundColor(useRedText ? .red : .blue)
    }
    
    // SwiftUI automatically watches all @State properties for changes & will reinvoke body property when one of them chanes
    // the color will immediately and automatically change
    @State private var useRedText = false
    
    var body5: some View {
        Button("Hello, world!") {
            useRedText.toggle()
        }
        .foregroundColor(useRedText ? .red : .blue)
    }
    
    //        var body6: some View {
    //            // SwiftUI is attaching atribute to body property (@ViewBuilder) This has the effect of silently wrapping multiple
    //            // views in one of those TupleView containers, so that even though it looks like we’re sending back multiple views
    //            // they get combined into one TupleView.
    //            Text("Hello")
    //            Text("World")
    //            Text("Goodbye")
    //            Text("World")
    //
    //        }
    
    var body7: some View {
        // VStack returns TupleView
        VStack {
            Text("Hello")
            Text("World")
            Text("Goodbye")
            Text("World")
        }
    }
    
    var body8: some View {
        Button("Hello world") {
            print(type(of: self.body))
        }
        // Order matters for modifier
        .frame(width: 200, height: 200)
        .background(.red)
    }
    
    var body9: some View {
        Text("Hello, world!")
        // There is no view behind this text box - if you wanted an entirely red background you would expand frame of textview
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

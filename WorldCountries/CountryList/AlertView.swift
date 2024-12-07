import SwiftUI

// ViewModifier для создания стандартного алерта с заголовком, сообщением и кнопкой OK
struct AlertView: ViewModifier {
    let title: String       // Заголовок алерта
    let message: String     // Сообщение алерта
    let isPresented: Binding<Bool>  // Binding для управления отображением алерта
    let onDismiss: () -> Void       // Замыкание, вызываемое при закрытии алерта
    
    func body(content: Content) -> some View {
        content
            .alert(
                LocalizedStringKey(title),    // Использование локализованного заголовка
                isPresented: isPresented,
                actions: {
                    Button("ok") {            // Кнопка OK для закрытия алерта
                        onDismiss()
                    }
                },
                message: {
                    Text(LocalizedStringKey(message))  // Локализованное сообщение
                }
            )
    }
}

// Расширение View для удобного использования AlertView
extension View {
    // Функция-модификатор для добавления алерта к любому View
    func alertView(
        title: String,
        message: String,
        isPresented: Binding<Bool>,
        onDismiss: @escaping () -> Void
    ) -> some View {
        modifier(AlertView(
            title: title,
            message: message,
            isPresented: isPresented,
            onDismiss: onDismiss
        ))
    }
}

// Предварительный просмотр для тестирования AlertView
#Preview {
    Text("Test View")
        .alertView(
            title: "error",          // Ключ локализации для заголовка
            message: "noNetwork",     // Ключ локализации для сообщения
            isPresented: .constant(true),  // Всегда показывать алерт в превью
            onDismiss: {}                  // Пустое действие при закрытии
        )
}
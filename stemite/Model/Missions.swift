import SwiftUI

// Modelo para una opción de respuesta
struct AnswerOption: Identifiable, Hashable {
    let id = UUID()
    let text: String
    var iconName: String? // Para SubChallengeDetailView
    var accentColor: Color? = nil // Para FlowDetectorPageView
    var isCorrect: Bool = false
}
// --- MODELOS PARA ONBOARDING ---
struct QuizQuestion: Identifiable, Hashable {
    let id = UUID()
    let questionText: String
    let options: [QuizOption]
}

struct QuizOption: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let imageName: String // Nombre de la imagen en tus assets
    let accentColor: Color // Color para el borde/feedback
    // var iconName: String? // Si lo necesitas para SubChallengeDetailView
    // var isCorrect: Bool = false // Si lo necesitas para SubChallengeDetailView
}
let sampleOnboardingQuestions: [QuizQuestion] = [
    QuizQuestion(questionText: "Si pudieras darle un extra a la tecnología, ¿qué te gustaría más? ✨🚀",
                 options: [
                    QuizOption(text: "Que las computadoras entiendan ideas y organicen todo solas. 🧠💻", imageName: "compu", accentColor: Color.blue), // Apunta a Sistemas
                    QuizOption(text: "Que los aparatos cobren vida con luces y energía al instante. 💡🔌", imageName: "devi", accentColor: Color.green), // Apunta a Electrónica
                    QuizOption(text: "Que las máquinas se muevan y nos ayuden como amigos mecánicos. 🦾🌟", imageName: "mach", accentColor: Color.red) // Apunta a Robótica
                 ]),

    QuizQuestion(questionText: "Cuando tu celular falla, ¿qué es lo primero que te preguntas? 🤔🔧",
                 options: [
                    QuizOption(text: "Cómo pensaba o qué instrucciones no siguió bien. 📝🤯", imageName: "smartphone", accentColor: Color.purple), // Apunta a Sistemas
                    QuizOption(text: "Qué piecita interna o 'chispa' dejó de funcionar correctamente. 🔩⚡", imageName: "board", accentColor: Color.orange), // Apunta a Electrónica
                    QuizOption(text: "Por qué sus partes no lograron trabajar juntas para hacer su tarea. ⚙️🤷", imageName: "cogs", accentColor: Color.cyan) // Apunta a Robótica
                 ]),

    QuizQuestion(questionText: "Imagina que tienes un taller de inventor. ¿Qué podrías hacer por horas? 🛠️🤩",
                 options: [
                    QuizOption(text: "Ideas y planes para que las computadoras hagan cosas nuevas y útiles. 💡📲", imageName: "think", accentColor: Color.teal), // Apunta a Sistemas
                    QuizOption(text: "Pequeños gadgets que se iluminen o hagan sonidos al tocarlos. ✨🔊", imageName: "leds", accentColor: Color.pink), // Apunta a Electrónica
                    QuizOption(text: "Juguetes que se muevan solos y exploren el mundo. 🤖🧭", imageName: "toys", accentColor: Color.yellow) // Apunta a Robótica
                 ])
]

// Modelo para un Sub-Reto (lección individual)
struct SubChallenge: Identifiable {
    let id = UUID()
    let missionTitle: String
    let currentStep: Int
    let totalSteps: Int
    let contextIconName: String?
    let contextTitle: String
    let contextText: String
    let questionText: String
    let options: [AnswerOption] // Aquí 'iconName' y 'isCorrect' son cruciales
    let explanationText: String
    let xpReward: Int
}

// --- DATOS DE EJEMPLO ---
enum MissionTagType: String { // Opcional, para las etiquetas
    case nuevo = "NUEVO"
    case popular = "POPULAR"
}
struct MissionTeaser: Identifiable {
    let id = UUID()
    let title: String // Título "phishing positivo"
    let imageName: String // Nombre de la imagen de fondo para la tarjeta
    let accentColor: Color // Color principal para la tarjeta o detalles
    let challengesCount: Int // Número de sub-retos/desafíos en la misión
    let xpRewardTotal: Int // XP total que se puede ganar en la misión
    let subtitle: String?
    let tag: MissionTagType?
    // Podrías añadir aquí el array de SubChallenges que componen esta misión
    // let subChallenges: [SubChallenge]
}

// Datos de Ejemplo para el Hub de Misiones - Optimizados para el espacio en CardView
let sampleMissionTeasers: [MissionTeaser] = [
    MissionTeaser(
        title: "FORTNITE A 120FPS CON ESTOS HACKS 🎮",
        imageName: "fortnite", // Debes tener esta imagen en Assets
        accentColor: Color(red: 0.0, green: 0.53, blue: 1.0), // Azul Fortnite
        challengesCount: 5,
        xpRewardTotal: 150,
        subtitle: "Descubre la optimización de hardware",
        tag: .popular
    ),
    MissionTeaser(
        title: "CHATGPT RESPONDE ASÍ A TUS PREGUNTAS 🤖",
        imageName: "ChatGPT", // Debes tener esta imagen en Assets
        accentColor: Color(red: 0.18, green: 0.8, blue: 0.44), // Verde ChatGPT
        challengesCount: 4,
        xpRewardTotal: 160,
        subtitle: "Explora cómo la IA aprende a pensar como humano",
        tag: .nuevo
    ),
    MissionTeaser(
        title: "CREA TU FILTRO VIRAL PARA TIKTOK 🎭",
        imageName: "tiktok", // Debes tener esta imagen en Assets
        accentColor: Color(red: 0.94, green: 0.3, blue: 0.3), // Rojo TikTok
        challengesCount: 6,
        xpRewardTotal: 180,
        subtitle: "Realidad aumentada en cualquier lugar",
        tag: .popular
    ),
    MissionTeaser(
        title: "DETECTIVE DIGITAL: RESUELVE MISTERIOS 🔍",
        imageName: "detect", // Debes tener esta imagen en Assets
        accentColor: Color(red: 0.22, green: 0.80, blue: 0.08), // Verde Lima
        challengesCount: 5,
        xpRewardTotal: 200,
        subtitle: "Descubre como se resguardan tus datos",
        tag: .nuevo
    ),
    MissionTeaser(
        title: "IDEA TU APP Y HAZTE MILLONARIO 💰📱",
        imageName: "code", // Debes tener esta imagen en Assets
        accentColor: Color(red: 1.0, green: 0.48, blue: 0.0), // Naranja
        challengesCount: 7,
        xpRewardTotal: 220,
        subtitle: "Desarrolla ideas de aplicaciones y aprende programación",
        tag: .popular
    ),
    MissionTeaser(
        title: "ROBOT QUE HACE TU TAREA EN SECRETO 🤖",
        imageName: "robo", // Debes tener esta imagen en Assets
        accentColor: Color(red: 0.91, green: 0.2, blue: 0.25), // Rojo robot
        challengesCount: 5,
        xpRewardTotal: 210,
        subtitle: "Como se mueven los brazos de un robot ",
        tag: .popular
    )
]
// Para SubChallengeDetailView y MissionPlayerView
let sampleSubChallenge1 = SubChallenge(
    missionTitle: "El Código Secreto de los Likes",
    currentStep: 1,
    totalSteps: 2, // Total de pasos en esta misión
    contextIconName: "lightbulb.fill",
    contextTitle: "El Algoritmo Chismoso",
    contextText: "¿No te saca de pedo que TikTok te aviente justo el video que querías ver? No es que te lean la mente (o bueno, casi). ¡Son los algoritmos, esos compas invisibles! Vamos a ver cómo jalan...",
    questionText: "Si el algoritmo ve que a un usuario le MAMA el K-Pop y los videos de gatitos con outfits chistosos, ¿cuál de estos videos crees que le aventaría después para que se quede PICADO?",
    options: [
        AnswerOption(text: "Video de recetas de cocina con música clásica 🥱", iconName: "fork.knife.circle.fill"),
        AnswerOption(text: "Un gatito bailando K-Pop con un outfit ridículo 😹🎶", iconName: "cat.fill", isCorrect: true),
        AnswerOption(text: "Noticiero sobre economía global 📊", iconName: "chart.line.uptrend.xyaxis.circle.fill")
    ],
    explanationText: "¡Exacto! Los algoritmos buscan patrones. Si te gusta el K-Pop y los gatos, ¡un gato bailando K-Pop es el match perfecto para mantenerte viendo! Así funcionan estas plataformas, analizando tus gustos para darte más de lo que te engancha. ¡Pura ingeniería de datos, mi chavo!",
    xpReward: 25
)

let sampleSubChallenge2 = SubChallenge(
    missionTitle: "El Código Secreto de los Likes",
    currentStep: 2,
    totalSteps: 2,
    contextIconName: "camera.filters",
    contextTitle: "Filtros Nivel Hollywood",
    contextText: "¿Viste ese filtro que te hace ver como estrella de cine o te pone cuernitos de diablo? No es magia negra (bueno, un poquito de magia de código sí). ¡Es pura creatividad digital!",
    questionText: "Si quisieras crear un filtro que reaccione cuando alguien sonríe en la cámara, ¿qué crees que necesitaría 'aprender' el software primero?",
    options: [
        AnswerOption(text: "Adivinar tu signo zodiacal ♍️", iconName: "sparkles", isCorrect: false),
        AnswerOption(text: "Reconocer una cara y detectar una sonrisa 😄", iconName: "face.smiling.fill", isCorrect: true),
        AnswerOption(text: "Saber tu comida favorita 🍔", iconName: "fork.knife", isCorrect: false)
    ],
    explanationText: "¡Exacto! Para que un filtro reaccione a tu sonrisa, primero la compu tiene que 'ver' tu cara y luego 'entender' cuándo estás sonriendo. Eso se hace con algoritmos de visión por computadora e inteligencia artificial. ¡Así de listos son los filtros que usas diario!",
    xpReward: 30
)

let sampleSubChallenge3 = SubChallenge(
    missionTitle: "Gadgets que Valen Millones",
    currentStep: 1,
    totalSteps: 2,
    contextIconName: "gamecontroller.fill",
    contextTitle: "Controles que Sienten",
    contextText: "Cuando juegas y tu control vibra con una explosión, ¡se siente más real, ¿no? Esa vibración no es casualidad, está diseñada para meterte más en el juego.",
    questionText: "¿Qué crees que hace que un control vibre en el momento exacto de una explosión en tu videojuego favorito?",
    options: [
        AnswerOption(text: "Unos duendecillos adentro que lo sacuden 🧚", iconName: "figure.whimsical", isCorrect: false),
        AnswerOption(text: "El juego manda una señal al control para activar unos motorcitos 🎮⚡️", iconName: "gamecontroller.fill", isCorrect: true),
        AnswerOption(text: "El control adivina por el sonido de la TV 🔊", iconName: "speaker.wave.2.fill", isCorrect: false)
    ],
    explanationText: "¡Así es! El juego y la consola (o PC) están en constante comunicación con el control. Cuando ocurre un evento como una explosión, el juego envía una señal específica al control, que activa pequeños motores internos (llamados actuadores hápticos) para producir la vibración. ¡Pura mecatrónica y sistemas trabajando juntos!",
    xpReward: 20
)

let sampleSubChallenge4 = SubChallenge(
    missionTitle: "Gadgets que Valen Millones",
    currentStep: 2,
    totalSteps: 2,
    contextIconName: "headphones",
    contextTitle: "Sonido que Enamora (y Vende)",
    contextText: "Esos audífonos que te aíslan del mundo y hacen que tu música suene épica, ¿cómo lo logran? Hay un montón de ingeniería detrás de ese sonido perfecto.",
    questionText: "Para que unos audífonos con cancelación de ruido funcionen chido, ¿qué es lo MÁS importante que deben hacer además de reproducir tu música?",
    options: [
        AnswerOption(text: "Tener luces RGB bien llamativas ✨", iconName: "lightbulb.led.fill", isCorrect: false),
        AnswerOption(text: "Ser súper cómodos, como una almohada para tus orejas 😴", iconName: "ear.fill", isCorrect: false),
        AnswerOption(text: "Escuchar el ruido de afuera y generar un 'anti-ruido' para cancelarlo 🎧🔇", iconName: "waveform.path.ecg", isCorrect: true)
    ],
    explanationText: "¡Correcto! La cancelación activa de ruido es una maravilla de la ingeniería acústica y electrónica. Los audífonos tienen micrófonos que captan el sonido ambiental, y luego un chip procesa ese sonido y genera una onda sonora opuesta (el 'anti-ruido') que, al sumarse con el ruido original, ¡lo anula! Por eso sientes ese silencio mágico.",
    xpReward: 35
)

// --- DATOS DE EJEMPLO (AÑADE ESTOS A TUS YA EXISTENTES) ---

let sampleSubChallenge5 = SubChallenge(
    missionTitle: "El Secreto de los Gigantes Tech",
    currentStep: 1,
    totalSteps: 3, // Nueva misión
    contextIconName: "shippingbox.fill",
    contextTitle: "Entregas Nivel Flash de Amazon",
    contextText: "Pides algo en Amazon y ¡ZAS! a veces llega el mismo día. No es magia, es una operación logística y tecnológica que ni te imaginas, con robots y todo el show.",
    questionText: "¿Cuál crees que es el 'ingrediente secreto' principal que usan los robots en los almacenes de Amazon para moverse tan rápido y no chocar entre ellos?",
    options: [
        AnswerOption(text: "Que los robots tomaron mucho café ☕🤖", iconName: "cup.and.saucer.fill", isCorrect: false),
        AnswerOption(text: "Un sistema de IA que es como un Waze para robots 🧠🗺️", iconName: "network", isCorrect: true),
        AnswerOption(text: "Que son fans de 'Rápidos y Furiosos' y le meten nitro 🏎️💨", iconName: "car.fill", isCorrect: false)
    ],
    explanationText: "¡Le diste al clavo! Los almacenes de Amazon son una locura de inteligencia artificial y robótica. Cada robot sabe exactamente dónde está, a dónde ir, y cómo esquivar a sus compas, todo coordinado por un 'cerebro' central. ¡Pura ingeniería de sistemas y robótica aplicada para que tengas tus paquetes ASAP!",
    xpReward: 25
)

let sampleSubChallenge6 = SubChallenge(
    missionTitle: "El Secreto de los Gigantes Tech",
    currentStep: 2,
    totalSteps: 3,
    contextIconName: "wand.and.stars",
    contextTitle: "La 'Magia' de Netflix",
    contextText: "Abres Netflix y de volada te recomienda series o pelis que chance te laten un montón. ¿Brujería o tecnología avanzada?",
    questionText: "Para que Netflix te recomiende justo la serie que te va a picar, ¿qué tipo de 'datos' crees que analiza más de ti?",
    options: [
        AnswerOption(text: "Tu horóscopo y si Mercurio está retrógrado ♍️✨", iconName: "moon.stars.fill", isCorrect: false),
        AnswerOption(text: "Qué series ves, cuáles dejas a medias, y qué les gusta a gente con gustos parecidos 📺📊", iconName: "film.stack.fill", isCorrect: true),
        AnswerOption(text: "El color de tu pijama cuando ves series 👕🌈", iconName: "tshirt.fill", isCorrect: false)
    ],
    explanationText: "¡Exacto! Netflix usa algoritmos de Machine Learning súper potentes. Analizan TODO: qué ves, cuánto tiempo, si la terminas, qué calificas bien, y comparan tus patrones con millones de otros usuarios para 'predecir' qué te podría gustar. ¡Es como un chismógrafo digital gigante aprendiendo de todos!",
    xpReward: 30
)

let sampleSubChallenge7 = SubChallenge(
    missionTitle: "El Secreto de los Gigantes Tech",
    currentStep: 3,
    totalSteps: 3,
    contextIconName: "iphone.gen2.circle.fill", // Un ícono más moderno para Apple
    contextTitle: "El Ecosistema 'Atrapador' de Apple",
    contextText: "Si tienes un iPhone, chance también tienes una Mac, o un iPad, o AirPods... y todo funciona junto como por arte de magia. ¿Cómo le hacen?",
    questionText: "¿Cuál es la 'jugada maestra' de Apple para que sus dispositivos funcionen tan bien juntos y quieras tenerlos todos?",
    options: [
        AnswerOption(text: "Que Steve Jobs les echa bendiciones desde el cielo 🙏😇", iconName: "hand.thumbsup.fill", isCorrect: false),
        AnswerOption(text: "Un diseño de hardware y software súper integrado y protocolos de comunicación propios 💻🤝📱", iconName: "link.icloud.fill", isCorrect: true),
        AnswerOption(text: "Que le ponen un imán secreto a cada producto para que se atraigan 🧲😉", iconName: " Knoten", isCorrect: false) // SF Symbol " Knoten" (nudo) o "circle.grid.cross.fill"
    ],
    explanationText: "¡Así es! Apple es el rey de la integración. Diseñan su propio hardware (chips) y software (iOS, macOS) para que trabajen en perfecta armonía. Usan protocolos como AirDrop o Handoff para que la info fluya entre dispositivos sin broncas. Es una estrategia de ingeniería y diseño que crea una experiencia de usuario muy fluida... ¡y muy difícil de dejar!",
    xpReward: 25
)

let sampleSubChallenge8 = SubChallenge(
    missionTitle: "Tu Huella Digital: ¿Héroe o Villano?", // Nueva Misión
    currentStep: 1,
    totalSteps: 2,
    contextIconName: "lock.shield.fill",
    contextTitle: "Ciberseguridad para Noobs",
    contextText: "Andas por internet dejando rastros como migajas de pan: likes, comentarios, búsquedas... ¿Alguna vez te has preguntado quién podría estar viendo esas 'migajas'?",
    questionText: "Si un hacker quisiera robar tu contraseña de Instagram, ¿cuál de estas acciones tuyas se lo pondría MÁS FÁCIL?",
    options: [
        AnswerOption(text: "Usar '12345678' como contraseña en todas tus cuentas 🤦‍♂️🔑", iconName: "key.fill", isCorrect: true),
        AnswerOption(text: "Tener tu perfil de Insta en modo privado 🔒", iconName: "lock.fill", isCorrect: false),
        AnswerOption(text: "Cambiar tu foto de perfil cada semana 📸", iconName: "person.crop.circle.badge.plus", isCorrect: false)
    ],
    explanationText: "¡Totalmente! Usar contraseñas débiles y repetidas es como dejarle la puerta de tu casa abierta al ladrón con un letrero de 'Pásele, está solo'. La ciberseguridad empieza por contraseñas fuertes y únicas para cada servicio. ¡No se lo dejes fácil a los malos del cuento digital!",
    xpReward: 20
)



let misionGigantesTechSubChallenges: [SubChallenge] = [
    sampleSubChallenge5,
    sampleSubChallenge6,
    sampleSubChallenge7
]

let misionHuellaDigitalSubChallenges: [SubChallenge] = [
    sampleSubChallenge8
    // ... podrías añadir un subChallengeData9 aquí para completar esta misión
]

// Array de todas las misiones para tu `MissionPlayerView` o similar
let todasLasMisionesDisponibles: [[SubChallenge]] = [
    misionLikesSubChallenges,       // Misión 1
    misionGadgetsSubChallenges,     // Misión 2
    misionGigantesTechSubChallenges, // Misión 3
    misionHuellaDigitalSubChallenges // Misión 4
]

// --- Misiones Completas (Arrays de SubChallenges) ---
let misionLikesSubChallenges: [SubChallenge] = [
    sampleSubChallenge1,
    sampleSubChallenge2
]

let misionGadgetsSubChallenges: [SubChallenge] = [
    sampleSubChallenge3,
    sampleSubChallenge4
]

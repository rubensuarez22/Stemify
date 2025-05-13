import SwiftUI

struct RoleModel {
    var id: UUID = UUID()
    var name: String
    var title: String
    var organization: String
    var image: String // In a real app, this would be an actual image
}

struct Workplace {
    var id: UUID = UUID()
    var name: String
    var description: String
    var icon: String // This would be an image name in a real app
}

struct CareerInfo {
    var id: UUID = UUID()
    var name: String
    var description: String
    var skills: [String]
    var jobOpportunities: String
}

struct ProfileView: View {
    var user: User
    @State private var selectedCareer: String = "Computer Science"
    @State private var showRoleModelDetail: Bool = false
    @State private var showWorkplaceDetail: Bool = false
    @State private var showCareerDetail: Bool = false
    @State private var showCareersLocationView: Bool = false
    @State private var selectedRoleModel: RoleModel? = nil
    @State private var selectedWorkplace: Workplace? = nil
    
    // Example data
    let roleModels = [
        RoleModel(name: "Dra. Fei-Fei Li", title: "Pionera en IA", organization: "Universidad de Stanford", image: "feifei"),
        RoleModel(name: "Lisa Su", title: "CEO", organization: "AMD", image: "lisasu"),
        RoleModel(name: "Reshma Saujani", title: "Fundadora", organization: "Girls Who Code", image: "reshma"),
        RoleModel(name: "Gwynne Shotwell", title: "Presidenta", organization: "SpaceX", image: "gwynne")
    ]
    
    let workplaces = [
        Workplace(name: "Gigantes Tecnológicos", description: "Construye el futuro de la tecnología", icon: "laptop"),
        Workplace(name: "Startups", description: "Crea algo nuevo", icon: "rocket"),
        Workplace(name: "Investigación", description: "Expande los límites", icon: "chart")
    ]
    
    let careerInfos = [
        CareerInfo(
            name: "Computer Science",
            description: "La informática se enfoca en la teoría, diseño y aplicación de computadoras y sistemas computacionales. Incluye áreas como inteligencia artificial, desarrollo de software, seguridad cibernética y ciencia de datos.",
            skills: ["Pensamiento lógico", "Resolución de problemas", "Programación", "Análisis de datos"],
            jobOpportunities: "Desarrolladora de Software, Científica de Datos, Ingeniera de IA, Analista de Ciberseguridad"
        ),
        CareerInfo(
            name: "Electrical Engineering",
            description: "La ingeniería eléctrica se enfoca en el estudio y aplicación de electricidad, electrónica y electromagnetismo. Incluye diseño de circuitos, sistemas de energía y telecomunicaciones.",
            skills: ["Circuitos y electrónica", "Sistemas de control", "Procesamiento de señales", "Diseño de hardware"],
            jobOpportunities: "Ingeniera Eléctrica, Diseñadora de Circuitos, Ingeniera de Telecomunicaciones"
        ),
        CareerInfo(
            name: "Mechanical Engineering",
            description: "La ingeniería mecánica aplica principios de física para diseñar, analizar y mantener sistemas mecánicos. Abarca termodinámica, mecánica estructural y diseño de maquinaria.",
            skills: ["Diseño CAD", "Análisis de materiales", "Termodinámica", "Dinámica de fluidos"],
            jobOpportunities: "Ingeniera Mecánica, Diseñadora de Productos, Ingeniera Automotriz"
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Career Match Section
                careerMatchSection
                
                // Career Info Card
                careerInfoCard
                
                // CTA Button
                exploreButton
                
                // Role Models Section
                roleModelsSection
                
                // Workplaces Section
                workplacesSection
                
                // Recommended Missions
                recommendedMissionsSection
                
                Spacer(minLength: 50)
            }
            .padding(.horizontal)
            .background(Color.cream)
        }
        .background(Color.cream)
        .sheet(isPresented: $showRoleModelDetail) {
            if let model = selectedRoleModel {
                roleModelDetailView(model: model)
            }
        }
        .sheet(isPresented: $showWorkplaceDetail) {
            if let workplace = selectedWorkplace {
                workplaceDetailView(workplace: workplace)
            }
        }
        .sheet(isPresented: $showCareerDetail) {
            careerDetailView(careerInfo: careerInfos.first { $0.name == selectedCareer } ?? careerInfos[0])
        }
        .fullScreenCover(isPresented: $showCareersLocationView) {
            CareersLocationView(selectedCareer: "Ingeniería en Computación")
        }
    }
    
    // MARK: - Career Match Section
    var careerMatchSection: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Tu Carrera STEM Ideal ✨")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primaryTextColor)
            
            Text("Basado en tus habilidades e intereses")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
            
            HStack(alignment: .top, spacing: 15) {
                // Second Place - Electrical Engineering
                careerCard(
                    career: "Electrical Engineering",
                    displayName: "Ingeniería Eléctrica",
                    icon: "bolt.fill",
                    percentage: user.skills?["Electrical Engineering"] ?? 0,
                    isSelected: selectedCareer == "Electrical Engineering",
                    position: "2º LUGAR"
                )
                
                // First Place - Computer Science
                careerCard(
                    career: "Computer Science",
                    displayName: "Ingeniería en Computación",
                    icon: "laptopcomputer",
                    percentage: user.skills?["Computer Science"] ?? 0,
                    isSelected: selectedCareer == "Computer Science",
                    position: "1er LUGAR"
                )
                .scaleEffect(1.1)
                .zIndex(1)
                
                // Third Place - Mechanical Engineering
                careerCard(
                    career: "Mechanical Engineering",
                    displayName: "Ingeniería Mecánica",
                    icon: "gear",
                    percentage: user.skills?["Mechanical Engineering"] ?? 0,
                    isSelected: selectedCareer == "Mechanical Engineering",
                    position: "3er LUGAR"
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 5)
        }
        .padding()
    }
    
    // Career Card
    func careerCard(career: String, displayName: String, icon: String, percentage: Int, isSelected: Bool, position: String) -> some View {
        Button {
            withAnimation {
                selectedCareer = career
            }
        } label: {
            VStack {
                // Position
                Text(position)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.azuli)
                    )
                    .offset(y: -15)
                    .zIndex(1)
                
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(isSelected ? .azuli : .primaryTextColor)
                    .padding(.bottom, 5)
                
                Text(displayName)
                    .font(.system(size: 14, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primaryTextColor)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                Text("\(percentage)%")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.azuli)
                    .padding(.top, 2)
                
                Spacer()
            }
            .frame(height: 140)
            .padding(.top, 10)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.azuli : Color.clear, lineWidth: 2)
            )
            .padding(.bottom, 10) // Reducido de 30 a 10
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Career Info Card
    var careerInfoCard: some View {
        let currentCareerInfo = careerInfos.first { $0.name == selectedCareer } ?? careerInfos[0]
        
        return Button {
            showCareerDetail = true
        } label: {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Sobre esta Carrera")
                        .font(.headline)
                        .foregroundColor(.primaryTextColor)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.azuli)
                        .font(.system(size: 16))
                }
                
                Text(currentCareerInfo.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Habilidades Clave:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primaryTextColor)
                    
                    HStack {
                        ForEach(currentCareerInfo.skills.prefix(2), id: \.self) { skill in
                            HStack(spacing: 5) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.azuli)
                                    .font(.system(size: 14))
                                Text(skill)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            if skill != currentCareerInfo.skills.prefix(2).last {
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.top, 5)
                
                HStack {
                    Text("Más información")
                        .font(.subheadline)
                        .foregroundColor(.azuli)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                .padding(.top, 5)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Career Detail View
    func careerDetailView(careerInfo: CareerInfo) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        let careerDisplayName = careerInfo.name == "Computer Science" ? "Ingeniería en Computación" :
                                               careerInfo.name == "Electrical Engineering" ? "Ingeniería Eléctrica" :
                                               careerInfo.name == "Mechanical Engineering" ? "Ingeniería Mecánica" : careerInfo.name
                        
                        Text(careerDisplayName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryTextColor)
                        
                        Spacer()
                        
                        // Icon
                        let icon = careerInfo.name == "Computer Science" ? "laptopcomputer" :
                                  careerInfo.name == "Electrical Engineering" ? "bolt.fill" :
                                  careerInfo.name == "Mechanical Engineering" ? "gear" : "graduationcap"
                        
                        Image(systemName: icon)
                            .font(.system(size: 36))
                            .foregroundColor(.azuli)
                    }
                    
                    Rectangle()
                        .fill(Color.azuli)
                        .frame(height: 4)
                        .frame(width: 100)
                }
                .padding(.horizontal)
                
                // Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Descripción")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryTextColor)
                    
                    Text(careerInfo.description)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal)
                
                // Skills
                VStack(alignment: .leading, spacing: 10) {
                    Text("Habilidades Clave")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryTextColor)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(careerInfo.skills, id: \.self) { skill in
                            HStack(alignment: .top, spacing: 15) {
                                Circle()
                                    .fill(Color.azuli)
                                    .frame(width: 25, height: 25)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white)
                                    )
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(skill)
                                        .font(.headline)
                                        .foregroundColor(.primaryTextColor)
                                    
                                    Text("Esta habilidad es fundamental para el éxito en esta carrera. Los profesionales que dominan \(skill.lowercased()) tienen una ventaja competitiva en el mercado laboral.")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            if skill != careerInfo.skills.last {
                                Divider()
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal)
                
                // Job Opportunities
                VStack(alignment: .leading, spacing: 10) {
                    Text("Oportunidades Laborales")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryTextColor)
                    
                    let jobs = careerInfo.jobOpportunities.components(separatedBy: ", ")
                    
                    VStack(spacing: 15) {
                        ForEach(jobs, id: \.self) { job in
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(job)
                                        .font(.headline)
                                        .foregroundColor(.primaryTextColor)
                                    
                                    Text("Salario promedio: $75,000 - $120,000")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "briefcase.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.azuli)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 2)
                            )
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal)
                
                // Education Path
                VStack(alignment: .leading, spacing: 10) {
                    Text("Camino Educativo")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryTextColor)
                    
                    HStack(spacing: 0) {
                        educationStepCard(
                            step: "1",
                            title: "Bachillerato",
                            description: "Enfócate en matemáticas y ciencias",
                            timeframe: "3 años"
                        )
                        
                        Rectangle()
                            .fill(Color.azuli)
                            .frame(width: 30, height: 2)
                        
                        educationStepCard(
                            step: "2",
                            title: "Universidad",
                            description: "Licenciatura en \(careerInfo.name == "Computer Science" ? "Ingeniería en Computación" : careerInfo.name == "Electrical Engineering" ? "Ingeniería Eléctrica" : "Ingeniería Mecánica")",
                            timeframe: "4-5 años"
                        )
                        
                        Rectangle()
                            .fill(Color.azuli)
                            .frame(width: 30, height: 2)
                        
                        educationStepCard(
                            step: "3",
                            title: "Especialización",
                            description: "Maestría o certificaciones",
                            timeframe: "1-2 años"
                        )
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal)
                
                Spacer(minLength: 30)
            }
            .padding(.vertical)
            .background(Color.cream)
        }
        .background(Color.cream)
    }
    
    // Función para obtener el nombre en español de la carrera seleccionada
    func getSpanishCareerName(_ careerName: String) -> String {
        switch careerName {
        case "Computer Science":
            return "Ingeniería en Computación"
        case "Electrical Engineering":
            return "Ingeniería Eléctrica"
        case "Mechanical Engineering":
            return "Ingeniería Mecánica"
        default:
            return careerName
        }
    }
    
    // MARK: - Explore Button
    var exploreButton: some View {
        Button {
            // Inicia la vista de exploración de carreras con la carrera seleccionada
            showCareersLocationView = true
        } label: {
            HStack {
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 18))
                Text("Explorar Programas Cerca de Ti")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.azuli)
                    .shadow(color: Color.azuli.opacity(0.3), radius: 10, x: 0, y: 5)
            )
        }
        .padding(.horizontal)
    }
    
    // MARK: - Role Models Section
    var roleModelsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Título dinámico que muestra la carrera seleccionada
            Text("Mujeres Exitosas en \(getSpanishCareerName(selectedCareer)) 💪")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primaryTextColor)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(roleModels, id: \.id) { model in
                        roleModelCard(model: model)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    func roleModelCard(model: RoleModel) -> some View {
        Button {
            selectedRoleModel = model
            showRoleModelDetail = true
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                // Profile image
                Circle()
                    .fill(Color.azuli.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        ZStack {
                            Circle()
                                .stroke(Color.azuli, lineWidth: 2)
                            // In a real app, you'd use an actual image
                            Text(String(model.name.prefix(1)))
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(.azuli)
                        }
                    )
                    .padding(.bottom, 5)
                
                Text(model.name)
                    .font(.headline)
                    .foregroundColor(.primaryTextColor)
                
                Text(model.title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(model.organization)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                Spacer()
            }
            .frame(width: 150, height: 200)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func roleModelDetailView(model: RoleModel) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header with profile image
            HStack(spacing: 15) {
                Circle()
                    .fill(Color.azuli.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay(
                        ZStack {
                            Circle()
                                .stroke(Color.azuli, lineWidth: 2)
                            Text(String(model.name.prefix(1)))
                                .font(.system(size: 40, weight: .semibold))
                                .foregroundColor(.azuli)
                        }
                    )
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(model.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryTextColor)
                    
                    Text(model.title)
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text(model.organization)
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            // Bio
            VStack(alignment: .leading, spacing: 10) {
                Text("Biografía")
                    .font(.headline)
                    .foregroundColor(.primaryTextColor)
                
                Text("Esta es una biografía detallada sobre \(model.name) y sus contribuciones al campo. En una aplicación real, este texto incluiría información sobre su educación, logros importantes, premios y el impacto que ha tenido en su industria.")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .padding()
            
            // Career Path
            VStack(alignment: .leading, spacing: 10) {
                Text("Trayectoria Profesional")
                    .font(.headline)
                    .foregroundColor(.primaryTextColor)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack(alignment: .top, spacing: 15) {
                        Circle()
                            .fill(Color.azuli)
                            .frame(width: 15, height: 15)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Educación")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryTextColor)
                            
                            Text("Universidad prestigiosa")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 15) {
                        Circle()
                            .fill(Color.azuli)
                            .frame(width: 15, height: 15)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Primer Puesto")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryTextColor)
                            
                            Text("Empresa tecnológica líder")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 15) {
                        Circle()
                            .fill(Color.azuli)
                            .frame(width: 15, height: 15)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Posición Actual")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryTextColor)
                            
                            Text("\(model.title) en \(model.organization)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.cream)
    }
    
    // MARK: - Workplaces Section
    var workplacesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Donde Podrías Trabajar 🚀")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primaryTextColor)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(workplaces, id: \.id) { workplace in
                        workplaceCard(workplace: workplace)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 10)
    }
    
    func workplaceCard(workplace: Workplace) -> some View {
        Button {
            selectedWorkplace = workplace
            showWorkplaceDetail = true
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                // Icon
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.azuli.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: workplace.icon == "laptop" ? "laptopcomputer" :
                                         workplace.icon == "rocket" ? "rocket" : "chart.bar.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.azuli)
                    )
                    .padding(.bottom, 5)
                
                Text(workplace.name)
                    .font(.headline)
                    .foregroundColor(.primaryTextColor)
                
                Text(workplace.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .frame(width: 150, height: 150)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func workplaceDetailView(workplace: Workplace) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.azuli.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: workplace.icon == "laptop" ? "laptopcomputer" :
                                         workplace.icon == "rocket" ? "rocket" : "chart.bar.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.azuli)
                    )
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(workplace.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryTextColor)
                    
                    Text(workplace.description)
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 10)
            }
            .padding()
            
            // Description
            VStack(alignment: .leading, spacing: 10) {
                Text("Acerca de")
                    .font(.headline)
                    .foregroundColor(.primaryTextColor)
                
                Text("Aquí encontrarás una descripción detallada sobre cómo es trabajar en \(workplace.name). En una aplicación real, este texto incluiría información sobre la cultura de trabajo, beneficios, oportunidades de crecimiento y los tipos de proyectos en los que podrías trabajar.")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .padding()
            
            // Roles
            VStack(alignment: .leading, spacing: 15) {
                Text("Roles Disponibles")
                    .font(.headline)
                    .foregroundColor(.primaryTextColor)
                
                rolesCard(title: "Ingeniera de Software", salary: "$70,000 - $120,000")
                rolesCard(title: "Científica de Datos", salary: "$80,000 - $130,000")
                rolesCard(title: "Diseñadora de UX", salary: "$65,000 - $110,000")
            }
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.cream)
    }
    
    func rolesCard(title: String, salary: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryTextColor)
                
                Text(salary)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        )
    }
    
    // MARK: - Recommended Missions
    var recommendedMissionsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Próximos Pasos Recomendados 🎯")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primaryTextColor)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                missionCard(
                    title: "Programar un Juego Simple",
                    description: "Crea tu primer juego usando Swift",
                    difficulty: "Principiante",
                    time: "2 horas"
                )
                
                missionCard(
                    title: "Construir un Modelo de IA",
                    description: "Entrena una IA para reconocer imágenes",
                    difficulty: "Intermedio",
                    time: "4 horas"
                )
                
                missionCard(
                    title: "Participar en un Hackathon",
                    description: "Colabora con otros para construir algo genial",
                    difficulty: "Avanzado",
                    time: "Fin de semana"
                )
            }
            .padding(.horizontal)
        }
        .padding(.top, 10)
    }
    
    func missionCard(title: String, description: String, difficulty: String, time: String) -> some View {
        Button {
            // Show mission details
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primaryTextColor)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text(difficulty)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.azuli.opacity(0.2))
                            )
                            .foregroundColor(.azuli)
                        
                        Text(time)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue.opacity(0.2))
                            )
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

func educationStepCard(step: String, title: String, description: String, timeframe: String) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.azuli)
                    .frame(width: 35, height: 35)
                
                Text(step)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primaryTextColor)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Text(timeframe)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.azuli.opacity(0.2))
                )
                .foregroundColor(.azuli)
        }
        .frame(width: 100)
        .padding(.vertical)
    }


let exampleUsers = [
    User(id: UUID(), gender: "Female")
]

#Preview {
    ProfileView(user: exampleUsers.first!)
}

import SwiftUI


struct RoleModel {
    var id: UUID = UUID()
    var name: String
    var title: String
    var organization: String
    var image: String // In a real app, this would be an actual image
    var bio: String
    var career: String // Associated career field
}

struct Workplace {
    var id: UUID = UUID()
    var name: String
    var description: String
    var icon: String // This would be an image name in a real app
    var details: String
    var career: String // Associated career field
}

struct ProfileView: View {
    var user: User
    @State private var selectedCareer: String = "Computer Science"
    @State private var showRoleModelDetails: Bool = false
    @State private var selectedRoleModel: RoleModel?
    @State private var showWorkplaceDetails: Bool = false
    @State private var selectedWorkplace: Workplace?
    
    // Example data - organized by career
    let roleModelsData: [RoleModel] = [
        // Computer Science Role Models
        RoleModel(
            name: "Dr. Fei-Fei Li",
            title: "AI Pioneer",
            organization: "Stanford University",
            image: "feifei",
            bio: "Dr. Fei-Fei Li is a Professor of Computer Science at Stanford University and Co-Director of Stanford's Human-Centered AI Institute. She served as VP at Google and Chief Scientist of AI/ML at Google Cloud. Her research focuses on computer vision, machine learning, and AI. She is known for creating ImageNet, a dataset that revolutionized computer vision and deep learning.",
            career: "Computer Science"
        ),
        RoleModel(
            name: "Kimberly Bryant",
            title: "Founder",
            organization: "Black Girls Code",
            image: "kimberly",
            bio: "Kimberly Bryant is an electrical engineer who founded Black Girls Code, a non-profit organization dedicated to teaching programming skills to young girls of color. With over 25 years of experience in the tech industry at companies like Genentech and Pfizer, Bryant is working to close the digital divide for girls of color.",
            career: "Computer Science"
        ),
        
        // Electrical Engineering Role Models
        RoleModel(
            name: "Lisa Su",
            title: "CEO",
            organization: "AMD",
            image: "lisasu",
            bio: "Dr. Lisa Su is the President and CEO of Advanced Micro Devices (AMD). Under her leadership, AMD has made significant technological advances in high-performance computing. She has a Ph.D. in Electrical Engineering from MIT and has been named one of the World's Greatest Leaders by Fortune. Before joining AMD, she worked at IBM, Texas Instruments, and Freescale Semiconductor.",
            career: "Electrical Engineering"
        ),
        RoleModel(
            name: "Limor Fried",
            title: "Founder & CEO",
            organization: "Adafruit Industries",
            image: "limor",
            bio: "Limor Fried, also known as 'Ladyada', is an electrical engineer and founder of Adafruit Industries, an open-source hardware company. She was the first female engineer to be featured on the cover of WIRED magazine and was awarded Entrepreneur of the Year by Entrepreneur magazine in 2012. She's known for her commitment to open-source hardware and STEM education.",
            career: "Electrical Engineering"
        ),
        
        // Mechanical Engineering Role Models
        RoleModel(
            name: "Gwynne Shotwell",
            title: "President & COO",
            organization: "SpaceX",
            image: "gwynne",
            bio: "Gwynne Shotwell is the President and Chief Operating Officer of SpaceX. She is responsible for day-to-day operations and managing customer relationships. With a background in mechanical engineering and applied mathematics, she has helped grow SpaceX from a small startup to a leading aerospace manufacturer and space transportation services company valued at over $100 billion.",
            career: "Mechanical Engineering"
        ),
        RoleModel(
            name: "Debbie Sterling",
            title: "Founder & CEO",
            organization: "GoldieBlox",
            image: "debbie",
            bio: "Debbie Sterling is a mechanical engineer and founder of GoldieBlox, a company that creates engineering toys designed specifically for girls. She developed GoldieBlox to inspire girls to pursue STEM fields. Sterling graduated from Stanford University with a degree in Mechanical Engineering and Product Design and was named one of Time's 100 Most Influential People.",
            career: "Mechanical Engineering"
        )
    ]
    
    let workplacesData: [Workplace] = [
        // Computer Science Workplaces
        Workplace(
            name: "Google",
            description: "Build products that billions use daily",
            icon: "laptop",
            details: "Google offers numerous roles for computer scientists from software engineering to AI research. You could work on products like Search, Gmail, or cutting-edge AI projects like DeepMind. The average software engineer at Google earns over $180,000 annually with generous benefits, development opportunities, and a collaborative culture.",
            career: "Computer Science"
        ),
        Workplace(
            name: "Fintech Startups",
            description: "Transform the financial industry",
            icon: "rocket",
            details: "Financial technology startups like Stripe, Robinhood, and Coinbase offer fast-paced environments where computer scientists can revolutionize how people interact with money. These companies offer competitive salaries ($130,000-$200,000), equity packages, and the chance to build products used by millions of people.",
            career: "Computer Science"
        ),
        Workplace(
            name: "Research Labs",
            description: "Push the boundaries of AI",
            icon: "chart",
            details: "Research labs like OpenAI, FAIR (Facebook AI Research), and Microsoft Research employ computer scientists to advance the field of artificial intelligence. These positions typically require advanced degrees but offer the opportunity to publish papers, attend conferences, and shape the future of technology.",
            career: "Computer Science"
        ),
        
        // Electrical Engineering Workplaces
        Workplace(
            name: "Tesla",
            description: "Accelerate sustainable energy",
            icon: "bolt.fill",
            details: "Tesla employs electrical engineers to work on electric vehicles, energy storage, and solar products. Engineers at Tesla design power electronics, battery management systems, and charging solutions. The company offers competitive compensation ($120,000-$180,000) and the opportunity to work on products addressing climate change.",
            career: "Electrical Engineering"
        ),
        Workplace(
            name: "Intel",
            description: "Design next-gen processors",
            icon: "cpu",
            details: "Intel is a leading semiconductor company where electrical engineers design microprocessors powering computers worldwide. At Intel, you could work on chip design, verification, or manufacturing processes. The company offers stable employment, comprehensive benefits, and average salaries around $150,000 for experienced engineers.",
            career: "Electrical Engineering"
        ),
        Workplace(
            name: "Networking Companies",
            description: "Build the internet's backbone",
            icon: "network",
            details: "Companies like Cisco and Juniper Networks employ electrical engineers to design and develop networking hardware and software. These roles involve creating routers, switches, and security devices that form the internet's infrastructure, with salaries ranging from $110,000 to $170,000 depending on experience.",
            career: "Electrical Engineering"
        ),
        
        // Mechanical Engineering Workplaces
        Workplace(
            name: "Aerospace Companies",
            description: "Design aircraft and spacecraft",
            icon: "airplane",
            details: "Companies like Boeing, Lockheed Martin, and NASA employ mechanical engineers to design aircraft, spacecraft, and propulsion systems. These positions require knowledge of fluid dynamics, materials science, and thermal systems, with salaries ranging from $90,000 to $150,000 and excellent stability.",
            career: "Mechanical Engineering"
        ),
        Workplace(
            name: "Automotive Industry",
            description: "Create future vehicles",
            icon: "car",
            details: "Automotive companies like Ford, GM, and Toyota hire mechanical engineers to design vehicle systems including powertrains, chassis, and HVAC systems. The industry is rapidly evolving with electric and autonomous vehicles, creating exciting opportunities with compensation typically between $85,000 and $130,000.",
            career: "Mechanical Engineering"
        ),
        Workplace(
            name: "Medical Device Companies",
            description: "Develop life-saving technology",
            icon: "heart",
            details: "Medical device manufacturers like Medtronic, Boston Scientific, and Stryker employ mechanical engineers to design equipment that improves patient outcomes. These roles combine engineering principles with healthcare applications and offer salaries from $95,000 to $140,000 with the satisfaction of creating products that save lives.",
            career: "Mechanical Engineering"
        )
    ]
    
    // Filtered lists based on selected career
    var filteredRoleModels: [RoleModel] {
        roleModelsData.filter { $0.career == selectedCareer }
    }
    
    var filteredWorkplaces: [Workplace] {
        workplacesData.filter { $0.career == selectedCareer }
    }
    
    // Mission recommendations based on selected career
    var missionRecommendations: [(String, String, String, String)] {
        switch selectedCareer {
        case "Computer Science":
            return [
                ("Build a Web App", "Create a full-stack application with React", "Intermediate", "8 hours"),
                ("Develop a Machine Learning Model", "Train an AI to classify images", "Advanced", "12 hours"),
                ("Complete an Algorithm Challenge", "Solve complex coding problems", "Beginner", "3 hours")
            ]
        case "Electrical Engineering":
            return [
                ("Design a Circuit", "Create a simple circuit with Arduino", "Beginner", "4 hours"),
                ("Build a Smart Home Device", "Program an IoT device", "Intermediate", "10 hours"),
                ("Design a Solar Power System", "Calculate and design renewable energy", "Advanced", "15 hours")
            ]
        case "Mechanical Engineering":
            return [
                ("3D Print a Prototype", "Design and print a functional object", "Beginner", "5 hours"),
                ("Build a Drone", "Assemble a small drone with basic components", "Intermediate", "12 hours"),
                ("Design a Cooling System", "Model heat transfer for electronic devices", "Advanced", "8 hours")
            ]
        default:
            return [
                ("Code a Simple Game", "Create your first game using Swift", "Beginner", "2 hours"),
                ("Build a Machine Learning Model", "Train an AI to recognize images", "Intermediate", "4 hours"),
                ("Join a Hackathon", "Collaborate with others to build something cool", "Advanced", "Weekend")
            ]
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Career Match Section
                careerMatchSection
                
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
    }
    
    // MARK: - Career Match Section
    var careerMatchSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your STEM Career Match ✨")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primaryTextColor)
            
            Text("Based on your skills & interests")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
            
            HStack(spacing: 15) {
                // Second Place - Electrical Engineering
                careerCard(
                    career: "Electrical Engineering",
                    icon: "bolt.fill",
                    percentage: user.skills?["Electrical Engineering"] ?? 0,
                    isSelected: selectedCareer == "Electrical Engineering"
                )
                
                // First Place - Computer Science
                careerCard(
                    career: "Computer Science",
                    icon: "laptopcomputer",
                    percentage: user.skills?["Computer Science"] ?? 0,
                    isSelected: selectedCareer == "Computer Science"
                )
                .scaleEffect(1.1)
                
                // Third Place - Mechanical Engineering
                careerCard(
                    career: "Mechanical Engineering",
                    icon: "gear",
                    percentage: user.skills?["Mechanical Engineering"] ?? 0,
                    isSelected: selectedCareer == "Mechanical Engineering"
                )
            }
            .padding(.top, 5)
        }
        .padding()
    }
    
    // Career Card
    func careerCard(career: String, icon: String, percentage: Int, isSelected: Bool) -> some View {
        Button {
            withAnimation {
                selectedCareer = career
            }
        } label: {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(isSelected ? .primaryOrange : .primaryTextColor)
                    .padding(.bottom, 5)
                
                Text(career)
                    .font(.system(size: 14, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primaryTextColor)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                Text("\(percentage)%")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primaryOrange)
                    .padding(.top, 2)
                
                Spacer()
            }
            .frame(height: 130)
            .padding(.top, 10)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.primaryOrange : Color.clear, lineWidth: 2)
            )
            .padding(.bottom, 30)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Explore Button
    var exploreButton: some View {
        Button {
            // Action for exploring programs
        } label: {
            HStack {
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 18))
                Text("Explore Programs Near You")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primaryOrange)
                    .shadow(color: Color.primaryOrange.opacity(0.3), radius: 10, x: 0, y: 5)
            )
        }
        .padding(.horizontal)
    }
    
    // MARK: - Role Models Section
    var roleModelsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Women Crushing It 💪")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primaryTextColor)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(filteredRoleModels, id: \.id) { model in
                        roleModelCard(model: model)
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showRoleModelDetails, content: {
            if let model = selectedRoleModel {
                roleModelDetailView(model: model)
            }
        })
    }
    
    func roleModelCard(model: RoleModel) -> some View {
        Button {
            selectedRoleModel = model
            showRoleModelDetails = true
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                // Profile image
                Circle()
                    .fill(Color.primaryOrange.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        ZStack {
                            Circle()
                                .stroke(Color.primaryOrange, lineWidth: 2)
                            // In a real app, you'd use an actual image
                            Text(String(model.name.prefix(1)))
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(.primaryOrange)
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
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with close button
                HStack {
                    Spacer()
                    Button {
                        showRoleModelDetails = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                
                // Profile image and name
                HStack(spacing: 15) {
                    Circle()
                        .fill(Color.primaryOrange.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(
                            ZStack {
                                Circle()
                                    .stroke(Color.primaryOrange, lineWidth: 2)
                                Text(String(model.name.prefix(1)))
                                    .font(.system(size: 40, weight: .semibold))
                                    .foregroundColor(.primaryOrange)
                            }
                        )
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(model.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryTextColor)
                        
                        Text(model.title)
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text(model.organization)
                            .font(.headline)
                            .foregroundColor(.primaryOrange)
                    }
                }
                .padding(.vertical)
                
                // Career label
                Text(model.career)
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.primaryOrange.opacity(0.2))
                    )
                    .foregroundColor(.primaryOrange)
                
                // Biography
                VStack(alignment: .leading, spacing: 10) {
                    Text("Biography")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryTextColor)
                    
                    Text(model.bio)
                        .font(.body)
                        .foregroundColor(.primaryTextColor)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Achievements
                VStack(alignment: .leading, spacing: 10) {
                    Text("Key Achievements")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryTextColor)
                    
                    achievementRow(icon: "star.fill", text: "Leader in \(model.career) field")
                    achievementRow(icon: "trophy.fill", text: "Recognized industry expert")
                    achievementRow(icon: "person.3.fill", text: "Mentor to young women in STEM")
                }
                
                // Connect button
                Button {
                    // Action to learn more
                } label: {
                    Text("Learn More About \(model.name)")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.primaryOrange)
                        )
                }
                .padding(.top)
            }
            .padding()
        }
        .background(Color.cream.ignoresSafeArea())
    }
    
    func achievementRow(icon: String, text: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.primaryOrange)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primaryTextColor)
        }
        .padding(.vertical, 5)
    }
    
    // MARK: - Workplaces Section
    var workplacesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Where You Could Work 🚀")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primaryTextColor)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(filteredWorkplaces, id: \.id) { workplace in
                        workplaceCard(workplace: workplace)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 10)
        .sheet(isPresented: $showWorkplaceDetails, content: {
            if let workplace = selectedWorkplace {
                workplaceDetailView(workplace: workplace)
            }
        })
    }
    
    func workplaceCard(workplace: Workplace) -> some View {
        Button {
            selectedWorkplace = workplace
            showWorkplaceDetails = true
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                // Icon
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primaryOrange.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: getIconForWorkplace(workplace))
                            .font(.system(size: 24))
                            .foregroundColor(.primaryOrange)
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
    
    func getIconForWorkplace(_ workplace: Workplace) -> String {
        switch workplace.icon {
            case "laptop": return "laptopcomputer"
            case "rocket": return "rocket"
            case "chart": return "chart.bar.fill"
            case "bolt.fill": return "bolt.fill"
            case "cpu": return "cpu"
            case "network": return "network"
            case "airplane": return "airplane"
            case "car": return "car.fill"
            case "heart": return "heart.fill"
            default: return "building.2.fill"
        }
    }
    
    func workplaceDetailView(workplace: Workplace) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with close button
                HStack {
                    Spacer()
                    Button {
                        showWorkplaceDetails = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                
                // Icon and name
                HStack(spacing: 15) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.primaryOrange.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: getIconForWorkplace(workplace))
                                .font(.system(size: 30))
                                .foregroundColor(.primaryOrange)
                        )
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(workplace.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryTextColor)
                        
                        Text(workplace.description)
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical)
                
                // Career label
                Text(workplace.career)
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.primaryOrange.opacity(0.2))
                    )
                    .foregroundColor(.primaryOrange)
                
                // Details
                VStack(alignment: .leading, spacing: 10) {
                    Text("What You Could Do Here")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryTextColor)
                    
                    Text(workplace.details)
                        .font(.body)
                        .foregroundColor(.primaryTextColor)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Skills needed
                VStack(alignment: .leading, spacing: 10) {
                    Text("Skills in Demand")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryTextColor)
                    
                    // Skills based on career type
                    if workplace.career == "Computer Science" {
                        skillRow(name: "Programming", level: 0.9)
                        skillRow(name: "Data Structures", level: 0.8)
                        skillRow(name: "Software Design", level: 0.7)
                    } else if workplace.career == "Electrical Engineering" {
                        skillRow(name: "Circuit Design", level: 0.9)
                        skillRow(name: "Embedded Systems", level: 0.8)
                        skillRow(name: "Signal Processing", level: 0.7)
                    } else {
                        skillRow(name: "3D Modeling", level: 0.9)
                        skillRow(name: "Thermodynamics", level: 0.8)
                        skillRow(name: "Material Science", level: 0.7)
                    }
                }
                
                // Connect button
                Button {
                    // Action to explore
                } label: {
                    Text("Explore Opportunities at \(workplace.name)")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.primaryOrange)
                        )
                }
                .padding(.top)
            }
            .padding()
        }
        .background(Color.cream.ignoresSafeArea())
    }
    
    func skillRow(name: String, level: Double) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(name)
                    .font(.subheadline)
                    .foregroundColor(.primaryTextColor)
                
                Spacer()
                
                Text("\(Int(level * 100))%")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 8)
                        .opacity(0.1)
                        .foregroundColor(.gray)
                    
                    Rectangle()
                        .frame(width: geometry.size.width * level, height: 8)
                        .foregroundColor(.primaryOrange)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
        }
        .padding(.vertical, 5)
    }
    
    // MARK: - Recommended Missions
    var recommendedMissionsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recommended Next Steps 🎯")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primaryTextColor)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                missionCard(
                    title: "Code a Simple Game",
                    description: "Create your first game using Swift",
                    difficulty: "Beginner",
                    time: "2 hours"
                )
                
                missionCard(
                    title: "Build a Machine Learning Model",
                    description: "Train an AI to recognize images",
                    difficulty: "Intermediate",
                    time: "4 hours"
                )
                
                missionCard(
                    title: "Join a Hackathon",
                    description: "Collaborate with others to build something cool",
                    difficulty: "Advanced",
                    time: "Weekend"
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
                                    .fill(Color.primaryOrange.opacity(0.2))
                            )
                            .foregroundColor(.primaryOrange)
                        
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

let exampleUsers = [
    User(id: UUID(), gender: "Female")
]

#Preview {
    ProfileView(user: exampleUsers.first!)
}

// Modelos necesarios para CareersLocationView
import SwiftUI
import MapKit
import CoreLocation


struct CareersLocationView: View {
    // MARK: - Properties
    @StateObject private var vm: UniversitiesViewModel
    @State private var locationManager = CLLocationManager()
    @State private var showSearchField: Bool = false
    @State private var searchText: String = ""
    @State private var searchResults: [MKMapItem] = []
    @FocusState private var isSearchFocused: Bool
    @State private var currentLocationName: String = "Buscando..."
    @Environment(\.dismiss) private var dismiss
    
    // Bottom sheet properties
    @State private var sheetHeight: CGFloat = 180
    @State private var isDragging: Bool = false
    @State private var showUniversityDetailView: Bool = false
    
    // Layout constants
    let maxWidthForIpad: CGFloat = 700
    let minHeight: CGFloat = 300
    let maxHeight: CGFloat = 600
    let selectedCareer: String
    
    // MARK: - Initialization
    init(selectedCareer: String) {
        // Guardar la carrera seleccionada
        self.selectedCareer = selectedCareer
        
        // Initialize location manager
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        
        // Initialize view model with selected career
        _vm = StateObject(wrappedValue: UniversitiesViewModel(
            selectedCareer: selectedCareer,
            locationManager: locManager
        ))
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Color.cream
                    .ignoresSafeArea()
                // Map layer
                mapLayer
                    .ignoresSafeArea(edges: [.leading, .trailing, .bottom])
                
                VStack(spacing: 0) {
                    // Header
                    if !showSearchField {
                        // Este espacio es para que el header no se superponga con la barra de navegación
                        Spacer().frame(height: 10)
                    }
                    
                    header
                        .padding(.horizontal)
                        .frame(maxWidth: maxWidthForIpad)
                    
                    if showSearchField && !searchResults.isEmpty {
                        searchResultsList
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .frame(maxWidth: maxWidthForIpad)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    Spacer()
                    
                    // Bottom sheet
                    bottomSheet
                }
            }
            .navigationTitle("Programas de \(selectedCareer)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color.azuli)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            // Filtrar solo universidades públicas
                        }) {
                            Label("Universidades Públicas", systemImage: "building.columns")
                        }
                        
                        Button(action: {
                            // Filtrar solo universidades privadas
                        }) {
                            Label("Universidades Privadas", systemImage: "building.2")
                        }
                        
                        Button(action: {
                            // Mostrar todas las universidades
                        }) {
                            Label("Todas", systemImage: "list.bullet")
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(Color.azuli)
                    }
                }
            }
            .sheet(isPresented: $showUniversityDetailView) {
                if let university = vm.selectedUniversity {
                    UniversityDetailView(university: university)
                }
            }
            .onChange(of: searchText) { newValue in
                if !newValue.isEmpty {
                    searchForLocations()
                } else {
                    searchResults = []
                }
            }
            .onAppear {
                updateCurrentLocationName(from: vm.mapRegion.center)
            }
        }
    }
    
    // MARK: - Map Layer
    private var mapLayer: some View {
        Map(coordinateRegion: $vm.mapRegion,
            showsUserLocation: true,
            annotationItems: vm.filteredUniversities
        ) { university in
            MapAnnotation(coordinate: university.coordinate) {
                UniversityMapAnnotationView()
                    .shadow(radius: 3)
                    .onTapGesture {
                        handleAnnotationTap(university: university)
                    }
            }
        }
    }
    
    // MARK: - Bottom Sheet
    private var bottomSheet: some View {
        VStack(spacing: 0) {
            // Handle
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: 40, height: 5)
                Spacer()
            }
            .padding(.top, 12)
            
            // Header
            HStack {
                Text("Universidades Encontradas")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 5)
                
                Spacer()
                Text("\(vm.filteredUniversities.count)")
                    .font(.headline)
                    .foregroundColor(Color.cream)
                    .frame(width: 30, height: 30)
                    .background(Circle().fill(
                        vm.filteredUniversities.isEmpty ? Color.gray : Color.azuli
                    ))
                    .padding()
            }
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(vm.filteredUniversities) { university in
                        UniversityCardView(university: university)
                            .onTapGesture {
                                vm.selectUniversity(university)
                                showUniversityDetailView = true
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
            .frame(maxHeight: sheetHeight)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cream)
        )
        .frame(height: sheetHeight)
        .frame(maxWidth: .infinity)
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    let newHeight = sheetHeight - value.translation.height
                    
                    // Limit height between min and max
                    if newHeight > minHeight && newHeight < maxHeight {
                        sheetHeight = newHeight
                    }
                }
                .onEnded { value in
                    isDragging = false
                    let velocity = value.predictedEndLocation.y - value.location.y
                    
                    // Snap to positions based on velocity and position
                    withAnimation(.spring()) {
                        if velocity > 100 || sheetHeight < minHeight + (maxHeight - minHeight) / 2 {
                            // Snap to minimum height
                            sheetHeight = minHeight
                        } else {
                            // Snap to maximum height
                            sheetHeight = maxHeight
                        }
                    }
                }
        )
        
        .animation(isDragging ? nil : .spring(), value: sheetHeight)
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(spacing: 0) {
            if showSearchField {
                // Search Field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Buscar ubicación...", text: $searchText)
                        .focused($isSearchFocused)
                        .font(.subheadline)
                        .autocorrectionDisabled()
                        .submitLabel(.search)
                    
                    Button {
                        showSearchField = false
                        searchText = ""
                        searchResults = []
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(10)
                .background(Color.cream.opacity(0.9))
                .cornerRadius(8)
                .padding(.bottom, 5)
                .onAppear {
                    isSearchFocused = true
                }
            } else {
                // Location Title Button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showSearchField = true
                    }
                }) {
                    Text(currentLocationName)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 10)
                        .overlay(alignment: .trailing) {
                            Image(systemName: "magnifyingglass")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .padding(.trailing, 10)
                        }
                }
                .background(Color.cream.opacity(0.9))
                .cornerRadius(8)
            }
        }
        .background(Color.cream)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Search Results List
    private var searchResultsList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(searchResults, id: \.self) { item in
                    Button {
                        navigateToLocation(item)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name ?? "Ubicación Desconocida")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                
                                if let locality = item.placemark.locality,
                                   let administrativeArea = item.placemark.administrativeArea {
                                    Text("\(locality), \(administrativeArea)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right.circle")
                                .foregroundColor(Color.azuli)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                    }
                    
                    Divider()
                        .padding(.leading)
                }
            }
            .padding(.vertical, 5)
        }
        .frame(maxHeight: min(CGFloat(searchResults.count * 60 + 10), 300))
    }
    
    // MARK: - Helper Functions
    private func searchForLocations() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = vm.mapRegion
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, error == nil else {
                DispatchQueue.main.async {
                    self.searchResults = []
                }
                return
            }
            DispatchQueue.main.async {
                self.searchResults = response.mapItems
            }
        }
    }
    
    private func handleAnnotationTap(university: University) {
        vm.selectUniversity(university)
        
        withAnimation(.spring()) {
            if sheetHeight < maxHeight * 0.9 {
                Rectangle()
                        .fill(Color.cream)
                        .frame(height: 300)
                        .offset(y: -1)
            }
        }
    }
    
    private func updateCurrentLocationName(from coordinate: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                self.currentLocationName = "Ubicación Desconocida"
                return
            }
            if let name = placemark.name, !name.contains("Unnamed Road"), name.count < 35 {
                self.currentLocationName = name
            } else if let locality = placemark.locality {
                self.currentLocationName = locality
            } else if let subAdminArea = placemark.subAdministrativeArea {
                self.currentLocationName = subAdminArea
            } else if let adminArea = placemark.administrativeArea {
                self.currentLocationName = adminArea
            } else {
                self.currentLocationName = "Área Desconocida"
            }
        }
    }
    
    private func navigateToLocation(_ mapItem: MKMapItem) {
        let coordinate = mapItem.placemark.coordinate
        let newRegion = MKCoordinateRegion(center: coordinate, span: vm.detailSpan)
        self.currentLocationName = mapItem.name ?? "Ubicación Desconocida"
        withAnimation(.easeInOut) {
            vm.mapRegion = newRegion
        }
        showSearchField = false
        searchText = ""
        searchResults = []
        isSearchFocused = false
    }
}

// MARK: - University Map Annotation View
struct UniversityMapAnnotationView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "building.columns.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .font(.headline)
                .foregroundColor(Color.azuli)
                .padding(6)
                .background(Color(uiColor: .systemBackground).opacity(0.7))
                .clipShape(Circle())
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.azuli)
                .frame(width: 10, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -2)
        }
    }
}

// MARK: - University Card View
struct UniversityCardView: View {
    let university: University
    
    var body: some View {
        HStack(spacing: 12) {
            // Image placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                
                if let imageURLString = university.imageURL,
                   let imageURL = URL(string: imageURLString) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure:
                            Image(systemName: "building.columns.fill")
                                .foregroundColor(.secondary)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "building.columns.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color.azuli.opacity(0.6))
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Information
            VStack(alignment: .leading, spacing: 4) {
                Text(university.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                // Address
                HStack(spacing: 2) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(Color.azuli)
                        .font(.caption2)
                    Text(university.address)
                        .lineLimit(1)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Careers count
                HStack(spacing: 2) {
                    Image(systemName: "graduationcap.fill")
                        .foregroundColor(Color.azuli)
                        .font(.caption2)
                    Text("\(university.careers.count) carreras disponibles")
                        .font(.caption)
                        .foregroundColor(Color.azuli)
                }
            }
            
            Spacer()
            
            // Arrow
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.cream)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - University Detail View
struct UniversityDetailView: View {
    let university: University
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    // Header with university name
                    Text(university.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    
                    // Image
                    if let imageURLString = university.imageURL,
                       let imageURL = URL(string: imageURLString) {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 180)
                                    .overlay(ProgressView())
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            case .failure:
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 180)
                                    .overlay(
                                        Image(systemName: "building.columns.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(.secondary)
                                    )
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 180)
                            .overlay(
                                Image(systemName: "building.columns.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.secondary)
                            )
                    }
                    
                    // Description
                    Text(university.description)
                        .font(.body)
                        .padding(.vertical, 5)
                    
                    // Address
                    HStack(alignment: .top) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(Color.azuli)
                        Text("Dirección: \(university.address)")
                    }
                    .padding(.vertical, 2)
                    
                    // Available careers section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Carreras Disponibles")
                            .font(.headline)
                            .padding(.top, 5)
                        
                        ForEach(university.careers, id: \.self) { career in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color.primaryOrange)
                                Text(career)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                    
                    // Website button
                    if let website = university.website {
                        Button {
                            openURL(website)
                        } label: {
                            HStack {
                                Image(systemName: "globe")
                                Text("Visitar Sitio Web")
                            }
                            .font(.headline)
                            .foregroundColor(Color.cream)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.azuli)
                            .cornerRadius(10)
                        }
                        .padding(.top, 10)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .background(
                Rectangle()
                    .fill(Color.cream) // Confirm this is defined correctly
            )
        }
    }
}

// Actualizar el ViewModel para aceptar el nuevo tipo de carrera
class UniversitiesViewModel: ObservableObject {
    // MARK: - Properties
    @Published var mapRegion: MKCoordinateRegion
    @Published var universities: [University] = []
    @Published var filteredUniversities: [University] = []
    @Published var selectedUniversity: University?
    
    // Map span settings
    let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let detailSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    // MARK: - Initialization
    init(selectedCareer: String, locationManager: CLLocationManager?) {
        // Initialize with current location or default location
        if let userLocation = locationManager?.location?.coordinate {
            self.mapRegion = MKCoordinateRegion(
                center: userLocation,
                span: defaultSpan
            )
        } else {
            // Default to Mexico City if user location not available
            self.mapRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332),
                span: defaultSpan
            )
        }
        
        loadUniversities()
        filterUniversities(for: selectedCareer)
    }
    
    // MARK: - Methods
    func loadUniversities() {
        // In a real app, this would load from an API or database
        // Sample data for demonstration
        let sampleUniversities = [
            University(
                name: "Universidad Nacional Autónoma de México",
                coordinate: CLLocationCoordinate2D(latitude: 19.3324, longitude: -99.1871),
                address: "Av. Universidad 3000, Ciudad Universitaria, Coyoacán",
                careers: ["Ingeniería en Computación", "Medicina", "Derecho", "Arquitectura"],
                description: "La UNAM es reconocida como una de las mejores universidades de América Latina, con una amplia oferta académica y programas de investigación.",
                website: URL(string: "https://www.unam.mx"),
                imageURL: "https://www.example.com/unam.jpg"
            ),
            University(
                name: "Instituto Politécnico Nacional",
                coordinate: CLLocationCoordinate2D(latitude: 19.4539, longitude: -99.1772),
                address: "Av. Luis Enrique Erro S/N, Zacatenco",
                careers: ["Ingeniería en Computación", "Ingeniería Civil", "Física", "Matemáticas"],
                description: "El IPN es una institución educativa del Estado creada para consolidar la independencia económica, científica y tecnológica del país.",
                website: URL(string: "https://www.ipn.mx"),
                imageURL: "https://www.example.com/ipn.jpg"
            ),
            University(
                name: "Universidad Autónoma Metropolitana",
                coordinate: CLLocationCoordinate2D(latitude: 19.3705, longitude: -99.0518),
                address: "Av. San Rafael Atlixco 186, Leyes de Reforma 1ra Sección",
                careers: ["Diseño", "Ingeniería en Computación", "Sociología", "Economía"],
                description: "La UAM es una universidad pública mexicana fundada en 1974 con un modelo educativo innovador y flexible.",
                website: URL(string: "https://www.uam.mx"),
                imageURL: "https://www.example.com/uam.jpg"
            ),
            University(
                name: "Tecnológico de Monterrey",
                coordinate: CLLocationCoordinate2D(latitude: 19.2842, longitude: -99.1388),
                address: "Calle del Puente 222, Ejidos de Huipulco",
                careers: ["Ingeniería en Computación", "Administración", "Medicina", "Arquitectura"],
                description: "El Tec de Monterrey es una universidad privada con reconocimiento internacional y enfoque en emprendimiento.",
                website: URL(string: "https://tec.mx"),
                imageURL: "https://www.example.com/tec.jpg"
            ),
            University(
                name: "Universidad Iberoamericana",
                coordinate: CLLocationCoordinate2D(latitude: 19.3702, longitude: -99.2650),
                address: "Prolongación Paseo de Reforma 880, Lomas de Santa Fe",
                careers: ["Diseño", "Comunicación", "Derecho", "Psicología"],
                description: "La Ibero es una universidad jesuita con enfoque humanista y compromiso social.",
                website: URL(string: "https://ibero.mx"),
                imageURL: "https://www.example.com/ibero.jpg"
            )
        ]
        
        self.universities = sampleUniversities
    }
    
    func filterUniversities(for career: String) {
        self.filteredUniversities = universities.filter { university in
            university.careers.contains(career)
        }
    }
    
    func selectUniversity(_ university: University) {
        self.selectedUniversity = university
        
        // Center map on selected university
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: university.coordinate,
                span: detailSpan
            )
        }
    }
}

// MARK: - Preview
#Preview {
    CareersLocationView(selectedCareer: "Ingeniería en Computación")
}

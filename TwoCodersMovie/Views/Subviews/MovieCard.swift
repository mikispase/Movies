struct MovieCard:View {
    let movie:Movie
    
    var body: some View {
        VStack(alignment: .leading) {
            PosterImage(url:movie.posterImage)
                .frame(width: 175, height:160)
                
            VStack(alignment: .leading, spacing: 0) {
                Text(movie.title ?? "")
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 14, weight: .semibold))

                Text(movie.overview?.truncated(toLength: 100) ?? "")
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 12))
                
            }
            Spacer()
        }
    }
}

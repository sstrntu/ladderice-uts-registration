FROM alpine:3.22 AS assets

RUN apk add --no-cache imagemagick libwebp-tools
WORKDIR /build
COPY posters ./posters

# Convert heavyweight PNG posters to resized WebP for faster wallpaper loading.
RUN mkdir -p /out/posters && \
    for file in posters/*.png; do \
      name="$(basename "$file" .png)"; \
      magick "$file" -strip -resize '720x900>' -quality 72 -define webp:method=6 "/out/posters/${name}.webp"; \
    done

FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html
COPY logos /usr/share/nginx/html/logos
COPY font.ttf /usr/share/nginx/html/font.ttf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=assets /out/posters /usr/share/nginx/html/posters

EXPOSE 80

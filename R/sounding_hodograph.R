#' Plot hodograph
#' 
#' Plot hodograph to show changes of wind speed and direction in vertical profile
#' 
#' @param u u-wind wind vector components (m/s)
#' @param v v-wind wind vector componente (m/s)
#' @param hght vector of altitudes (m)
#' @param max_hght max. altitude to be considered. 8 km used by default
#' @param max_speed max. isoline (circle) to be drawn for wind speed; 30 m/s used as default
#' @param lab_hghts label of numeric vector heights in km to be signed on hodograph; default: 1, 3, 6; NULL for skipping labels
#' @param ... other graphical parameters to be used with plot() function
#'
#' @export
#' @examples
#' data("sounding_wien")
#' attach(sounding_wien)
#' # changing wind speed and direction to U and V wind components
#' # also changing units from knots to m/s
#' u = round(-SKNT * 0.514444 * sin(DRCT * pi/180), 2)
#' v = round(-SKNT * 0.514444 * cos(DRCT * pi/180), 2)
#' # finally plot the hodograph:
#' sounding_hodograph(u, v, HGHT)
#' 


sounding_hodograph = function(u, v, hght, max_hght = 16000, max_speed = 25,
                     lab_hghts = c(0, 1, 3, 6, 9, 12), ...){
  
  # clipping to define max_hght
  ind = hght <= max_hght
  hght = hght[ind]
  u = u[ind]
  v = v[ind]
  
  # setting plot limits:
  #xlm = max(abs(range(c(u,v), na.rm = TRUE)))+1
  #xlm = ifelse(xlm > 61, 61, xlm)
  xlm = max_speed
  xlm = c(-xlm, xlm)
  
  # plotting layout for hodograph:
  par(pty = "s")
  plot(u, v, 
       #col = "blue",
       xlab = "", ylab = "",
       type = "n", 
       #lwd =3, 
       xlim = xlm, ylim = xlm, 
       asp = 1, 
       xaxt = "n", yaxt = "n", frame.plot = FALSE)
  #...)
  
  #abline(h = -20:20*5, lty = 2, col = "gray60")
  #abline(v = -20:20*5, lty = 2, col = "gray60")
  abline(h = 0, col = "gray40")
  abline(v = 0, col = "gray40")
  
  # draw circles on hodograph:
  draw_circle = function(speed = 5){ # current solution work for every 5 m/s
    up = round(speed * cos(0:359 * pi/180), 2)
    vp = round(speed * sin(0:359 * pi/180), 2)
    lty = ifelse( ((speed/5) %% 2 == 0), 1, 3)
    lines(up, vp, lty = lty, col = rgb(153, 153, 153, maxColorValue = 255, alpha = 125))
    if(lty == 1 & (speed/5) > 1) {
      points(up[135], vp[135], pch = 19, col = "white", cex = 3)
      text(up[135], vp[135], labels = speed, col = "gray20", cex = 0.7)
    }
  }
  
  sapply(seq(from = 0, to = max(xlm + 20), by = 5), draw_circle)
  
  # add units [m/s] in a hodograph corner
  up = round(max_speed * -1.55  * cos(135 * pi/180), 2)
  vp = round(max_speed * 1.35 * sin(135 * pi/180), 2)
  points(up, vp, pch = 19, col = "white", cex = 2)
  text(up, vp, labels = "[m/s]", col = "gray20", cex = 0.75)
  
  # finally adding lines to hodograph:
  
  # find surface level
  sfc = floor(hght/1000)[1]
  
  ux = approx(x = hght, y = u, xout = seq(from = sfc, to = 1000, by = 50))$y
  uy = approx(x = hght, y = v, xout = seq(from = sfc, to = 1000, by = 50))$y
  ux[1] = u[!is.na(u)][1]
  uy[1] = v[!is.na(v)][1]
  lines(ux, uy, lwd = 3, col = "magenta")
  
  ux = approx(x = hght, y = u, xout = seq(from = 1000, to = 3000, by = 50))$y
  uy = approx(x = hght, y = v, xout = seq(from = 1000, to = 3000, by = 50))$y
  #ux[1] = u[!is.na(u)][1]
  #uy[1] = v[!is.na(v)][1]
  lines(ux, uy, lwd = 3, col = "red")
  
  ux = approx(x = hght, y = u, xout = seq(from = 3000, to = 9000, by = 50))$y
  uy = approx(x = hght, y = v, xout = seq(from = 3000, to = 9000, by = 50))$y
  #ux[1] = u[!is.na(u)][1]
  #uy[1] = v[!is.na(v)][1]
  lines(ux, uy, lwd = 3, col = "orange")
  
  ux = approx(x = hght, y = u, xout = seq(from = 6000, to = 9000, by = 50))$y
  uy = approx(x = hght, y = v, xout = seq(from = 6000, to = 9000, by = 50))$y
  #ux[1] = u[!is.na(u)][1]
  #uy[1] = v[!is.na(v)][1]
  lines(ux, uy, lwd = 3, col = "yellow")
  
  ux = approx(x = hght, y = u, xout = seq(from = 9000, to = 12000, by = 50))$y
  uy = approx(x = hght, y = v, xout = seq(from = 9000, to = 12000, by = 50))$y
  #ux[1] = u[!is.na(u)][1]
  #uy[1] = v[!is.na(v)][1]
  lines(ux, uy, lwd = 3, col = "lightblue")
  
  #ux = approx(x = hght, y = u, xout = seq(from = 12000, to = 16000, by = 50))$y
  #uy = approx(x = hght, y = v, xout = seq(from = 12000, to = 16000, by = 50))$y
  #ux[1] = u[!is.na(u)][1]
  #uy[1] = v[!is.na(v)][1]
  #lines(ux, uy, lwd = 3, col = "lightblue")
  
  # adding label to heights if not NULL
  if(is.numeric(lab_hghts)){
    ux = approx(x = hght, y = u, xout = c(lab_hghts*1000))
    uy = approx(x = hght, y = v, xout = c(lab_hghts*1000))
    #points(ux$y, uy$y, cex = 0.5, pch = 19, col='black')
    points(ux$y, uy$y, cex = 1.15, pch = 21, col = rgb(255, 255, 255, maxColorValue = 255, alpha = 125), bg = rgb(255, 255, 255, maxColorValue = 255, alpha = 125))
    text(font=2, ux$y, uy$y, labels = floor(lab_hghts), col = "black", cex = 0.65)
  }
  
}
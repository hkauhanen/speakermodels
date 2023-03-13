require(ggplot2)
require(ggsci)


plot_noise <- function(df,
                       modelset = c("CRH", "VRH", "BRH", "qCRH", "qVRH")) {
  df <- model_selection(df, modelset=modelset)
  df$ID <- factor(df$ID)
  df$ID <- plyr::revalue(df$ID, c("K1"="Dataset: K1", "K2"="Dataset: K2", "PT"="Dataset: PT"))
  df$model <- factor(df$model, levels=modelset)
  df$Model <- df$model

  g <- ggplot(df, aes(x=noise, y=w, color=Model, pch=Model)) + geom_point() + geom_line() + facet_wrap(.~ID, ncol=1) + scale_x_log10() + xlab(expression("Noise fraction"~mu)) + ylab(expression("Akaike weight"~italic(w))) + theme_bw() + scale_color_locuszoom() + annotation_logticks(sides="b", size=0.3) + theme(panel.grid.minor=element_blank(), axis.text=element_text(color="black"), legend.position="top") + guides(color=guide_legend(title=""), pch=guide_legend(title=""))
  g
}


plot_all <- function(folder = "../plots") {
  # noise plot
  pdf(paste0(folder, "/noise-all.pdf"), width=6, height=8)
  print(plot_noise(noisesweep))
  dev.off()
}

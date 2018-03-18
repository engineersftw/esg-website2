const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    'window.$': 'jquery',
    'window.jQuery': 'jquery'
  })
)

const config = environment.toWebpackConfig()

config.resolve.alias = {
  'load-image': 'blueimp-load-image/js/load-image.js',
  'load-image-meta': 'blueimp-load-image/js/load-image-meta.js',
  'load-image-exif': 'blueimp-load-image/js/load-image-exif.js',
  'canvas-to-blob': 'blueimp-canvas-to-blob/js/canvas-to-blob.js',
  'load-image-scale': 'blueimp-load-image/js/load-image-scale.js',
  'jquery-ui/ui/widget': 'blueimp-file-upload/js/vendor/jquery.ui.widget.js'
}

module.exports = environment
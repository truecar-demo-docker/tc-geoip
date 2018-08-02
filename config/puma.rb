# Puma config
DEFAULT_THREADS = 4
DEFAULT_WORKERS = 1
max_threads = [
  ENV.fetch('PUMA_THREADS_MAX') { DEFAULT_THREADS }.to_i,
  ENV.fetch('PUMA_THREADS') { DEFAULT_THREADS }.to_i,
  ENV.fetch('PUMA_THREADS_MIN') { DEFAULT_THREADS }.to_i,
].max
min_threads = [
  ENV.fetch('PUMA_THREADS_MAX') { DEFAULT_THREADS }.to_i,
  ENV.fetch('PUMA_THREADS') { DEFAULT_THREADS }.to_i,
  ENV.fetch('PUMA_THREADS_MIN') { DEFAULT_THREADS }.to_i,
].min

workers ENV.fetch('PUMA_WORKERS') { DEFAULT_WORKERS }.to_i
threads min_threads, max_threads

preload_app!

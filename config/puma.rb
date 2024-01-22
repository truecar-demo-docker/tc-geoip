# Puma config
DEFAULT_THREADS = 4
DEFAULT_WORKERS = 1
MAX_THREADS = 16
MAX_WORKERS = 32

max_threads = [
  ENV.fetch('PUMA_THREADS_MAX', 0).to_i,
  ENV.fetch('PUMA_THREADS', 0).to_i,
  ENV.fetch('PUMA_THREADS_MIN', 0).to_i
].max
max_threads = max_threads.between?(1, MAX_THREADS) ? max_threads : DEFAULT_THREADS

min_threads = [
  ENV.fetch('PUMA_THREADS_MAX') { MAX_THREADS + 1 }.to_i,
  ENV.fetch('PUMA_THREADS') { MAX_THREADS + 1 }.to_i,
  ENV.fetch('PUMA_THREADS_MIN') { MAX_THREADS + 1 }.to_i
].min
min_threads = min_threads.between?(0, MAX_THREADS) ? min_threads : DEFAULT_THREADS

puma_workers = ENV.fetch('PUMA_WORKERS') { DEFAULT_WORKERS }.to_i
puma_workers = puma_workers.between?(1, MAX_WORKERS) ? puma_workers : DEFAULT_WORKERS

workers puma_workers
threads min_threads, max_threads

# Disable request logging because ALB logging is sufficient
quiet

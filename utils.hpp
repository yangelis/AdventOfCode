#ifndef UTILS_HPP__
#define UTILS_HPP__

#include <algorithm>
#include <assert.h>
#include <iostream>
#include <limits>
#include <string>
#include <string_view>
#include <vector>

// Unsigned
using u8 = uint8_t;
using u16 = uint16_t;
using u32 = uint32_t;
using u64 = uint64_t;

// Signed
using i8 = int8_t;
using i16 = int16_t;
using i32 = int32_t;
using i64 = int64_t;

// Floating point
using f32 = float;
using f64 = double;

namespace utils {

template <typename T> T mod(T a, T b) { return (a % b + b) % b; }
//////////////////////////////////////////////////
// Maybe
//////////////////////////////////////////////////
template <typename T> struct Maybe {
  bool has_value{};
  T unwrap{};
};

//////////////////////////////////////////////////
// Matrix
//////////////////////////////////////////////////
template <typename T> struct Matrix {
  size_t rows, cols;
  T *data{nullptr};

  Matrix(size_t r, size_t c) : rows(r), cols(c) { data = new T[rows * cols](); }
  Matrix(const Matrix<T> &m) : rows(m.rows), cols(m.cols), data(m.data) {}
  Matrix(Matrix<T> &&m) : rows(m.rows), cols(m.cols), data(std::move(m.data)) {}
  template <size_t r, size_t c> Matrix(T (&m)[r][c]) : Matrix(r, c) {
    for (size_t i = 0; i < rows; ++i) {
      for (size_t j = 0; j < cols; ++j) {
        (*this)(i, j) = m[i][j];
      }
    }
  }
  T &operator()(size_t i, size_t j) { return data[j + i * cols]; }

  const T &operator()(size_t i, size_t j) const { return data[j + i * cols]; }

  static inline Matrix<T> diagonal(size_t rows, size_t cols, T d = (T)1.0) {
    Matrix<T> ret(rows, cols);
    for (size_t i = 0; i < rows; ++i) {
      for (size_t j = 0; j < cols; ++j) {
        if (i == j) {
          ret(i, j) = d;
        }
      }
    }
    return ret;
  }

  T trace() {
    T tr = 0;
    if (cols == rows) {
      for (size_t i = 0; i < cols; ++i) {
        tr += ((*this)(i, i));
      }
      return tr;
    } else {
      return std::numeric_limits<T>::quiet_NaN();
    }
  }

  Matrix<T> transpose() {
    Matrix<T> result(cols, rows);
    for (size_t i = 0; i < cols; ++i) {
      for (size_t j = 0; j < rows; ++j) {
        result(i, j) = ((*this)(j, i));
      }
    }
    return result;
  }

  static inline Matrix<u8>
  create_mat_from_lines(const std::vector<std::string_view> &lines) {
    size_t h = lines.size();
    size_t w = lines[0].size();
    Matrix<u8> grid{h, w};

    for (size_t i = 0; i < h; ++i) {
      for (size_t j = 0; j < w; ++j) {
        grid(i, j) = lines[i][j];
      }
    }

    return grid;
  }
  void print() {
    for (size_t i = 0; i < rows; ++i) {
      for (size_t j = 0; j < cols; ++j) {
        std::cout << (*this)(i, j);
      }
      std::cout << '\n';
    }
  }
};

template <typename T> Matrix<T> hcat(const Matrix<T> &a, const Matrix<T> &b) {
  assert(a.rows == b.rows);
  size_t rows = a.rows;
  size_t cols = a.cols + b.cols;
  Matrix<T> ret(rows, cols);

  for (size_t i = 0; i < rows; ++i) {
    for (size_t j = 0; j < a.cols; ++j) {
      ret(i, j) = a(i, j);
    }
  }

  for (size_t i = 0; i < rows; ++i) {
    for (size_t j = a.cols; j < cols; ++j) {
      ret(i, j) = b(i, j - a.cols);
    }
  }
  return ret;
}

template <typename T> Matrix<T> hcat(const std::vector<Matrix<T>> &vec) {
  size_t rows = vec[0].rows;
  size_t cols = 0;
  for (const auto &m : vec) {
    cols += m.cols;
  }
  Matrix<T> ret(rows, cols);

  size_t cols_offset = 0;
  for (const auto &m : vec) {
    for (size_t i = 0; i < m.rows; ++i) {
      for (size_t j = 0; j < m.cols; ++j) {
        ret(i, j + cols_offset) = m(i, j);
      }
    }
    cols_offset += m.cols;
  }

  return ret;
}
// "stolen" from zhiayang
// https://github.com/zhiayang/adventofcode/blob/master/libs/aoc2.h
static inline std::string_view readFileRaw(const std::string &path) {
  FILE *f = fopen(path.c_str(), "r");
  if (!f)
    fprintf(stderr, "failed to open file '%s'\n", path.c_str()), abort();

  std::string input;
  fseek(f, 0, SEEK_END);

  long fsize = ftell(f);
  fseek(f, 0, SEEK_SET); // same as rewind(f);

  char *s = new char[fsize + 1];
  fread(s, fsize, 1, f);
  fclose(f);
  s[fsize] = 0;

  size_t n = fsize - 1;
  while (n > 0 && s[n] == '\n') {
    n--;
  }

  return std::string_view(s, n + 1);
}

static inline std::string read_file_as_string(const char *filename) {
  FILE *f = fopen(filename, "r");
  if (!f) {
    fprintf(stderr, "failed to open file '%s'\n", filename), abort();
  }
  std::string input;
  fseek(f, 0, SEEK_END);

  long fsize = ftell(f);
  fseek(f, 0, SEEK_SET); // same as rewind(f);

  char *s = new char[fsize + 1];
  fread(s, fsize, 1, f);
  fclose(f);
  s[fsize] = 0;

  size_t n = fsize;
  while (n > 0 && s[--n] == '\n')
    ;

  input = std::string(s, n + 1);
  delete[] s;

  return input;
}

static inline std::string replace(std::string input, const std::string &thing,
                                  const std::string &with) {
  while (true) {
    if (auto it = input.find(thing); it != std::string::npos)
      input.replace(it, thing.size(), with);

    else
      break;
  }

  return input;
}

static inline std::string_view read_file_as_string_view(const char *filename) {
  FILE *f = fopen(filename, "rb");
  if (!f)
    return {};

  int err = fseek(f, 0, SEEK_END);
  if (err < 0)
    return {};

  long size = ftell(f);
  if (size < 0)
    return {};

  err = fseek(f, 0, SEEK_SET);
  if (err < 0)
    return {};

  auto data = malloc(size);
  if (!data)
    return {};

  size_t read_size = fread(data, 1, size, f);
  if (read_size != (size_t)size && ferror(f))
    return {};

  fclose(f);
  return {static_cast<const char *>(data), static_cast<size_t>(size)};
}

static inline std::string_view chop_by_delim(std::string_view view,
                                             char delim) {
  size_t i = 0;
  while (i < view.size() && view.data()[i] != delim)
    ++i;
  std::string_view result = {view.data(), i};
  view.remove_prefix(i + 1);
  return result;
}

static inline std::string_view &trimr(std::string_view &s) {
  auto i = s.find_last_not_of(" \t\n\r\f\v");
  if (i != std::string_view::npos)
    s = s.substr(0, i + 1);

  return s;
}

static inline std::string_view &triml(std::string_view &s) {
  auto i = s.find_first_not_of(" \t\n\r\f\v");
  if (i != std::string_view::npos)
    s.remove_prefix(i);

  return s;
}

static inline std::string_view
join_string_view(const std::vector<std::string_view> &vec) {
  char *buffer = new char[1024];
  size_t i = 0;
  for (const auto &v : vec) {
    for (size_t j = 0; j < v.size(); ++j) {
      buffer[i + j] = v[j];
    }
    buffer[i + v.size()] = ' ';
    i += v.size() + 1;
  }
  return {buffer, i};
}

static inline std::vector<std::string_view> split_lines(std::string_view view,
                                                        char delim = '\n') {
  std::vector<std::string_view> ret;

  while (!view.empty()) {
    size_t len = view.find(delim);
    if (len != std::string_view::npos) {
      ret.emplace_back(view.data(), len);
      view.remove_prefix(len + 1);
    } else {
      break;
    }
  }
  if (!view.empty()) {
    ret.emplace_back(view.data(), view.length());
  }
  return ret;
}

static inline std::vector<std::string_view> split_by(std::string_view view,
                                                     std::string_view delim) {
  view = trimr(view);
  std::vector<std::string_view> ret;
  while (view.size() > 0) {
    auto len = view.find(delim);
    if (len == std::string_view::npos) {
      ret.push_back(view);
      break;
    }
    ret.push_back(view.substr(0, len));
    view = view.substr(len + delim.size());
  }
  return ret;
}

static inline std::vector<std::string_view> split_by(std::string_view view,
                                                     char delim) {
  return split_by(view, std::string_view(&delim, 1));
}

static inline std::vector<std::string_view>
read_lines_as_string_view(const char *filename) {
  auto lines = read_file_as_string_view(filename);
  return split_lines(lines, '\n');
}

template <typename T, typename Op>
std::vector<T> filter(Op &&fn, const std::vector<T> &v) {

  const auto n = v.size();
  std::vector<T> ret;
  ret.reserve(n);
  for (auto &&val : v) {
    if (fn(val)) {
      ret.emplace_back(val);
    }
  }
  return ret;
}

template <typename T, typename Op>
auto map(Op &&fn, const std::vector<T> &input)
    -> std::vector<decltype(fn(input[0]))> {
  std::vector<decltype(fn(input[0]))> ret;
  ret.reserve(input.size());
  for (const auto &x : input) {
    ret.push_back(fn(x));
  }
  return ret;
}

template <typename T, typename R, typename FoldOp>
R foldl(const R &i, const std::vector<T> &xs, FoldOp fn) {
  auto ret = i;
  for (const auto &x : xs) {
    ret = fn(ret, x);
  }
  return ret;
}

template <typename T> static inline T sum(const std::vector<T> &xs) {
  return foldl(T(), xs, [](const T &a, const T &b) -> T { return a + b; });
}

template <typename T>
static inline std::vector<T> arange(T start, T stop, T step = 1) {
  std::vector<T> values;

  if (step > 0) {
    for (T value = start; value < stop; value += step) {
      values.push_back(value);
    }
  } else {
    for (T value = start; value > stop; value += step) {
      values.push_back(value);
    }
  }
  return values;
}
// return the index
template <typename T, typename Op>
Maybe<i64> findfirst(Op &&fn, const std::vector<T> &h) {
  auto res = std::find(h.begin(), h.end(), fn);
  if (res != h.end()) {
    return {1, distance(h.begin(), res)};
  } else {
    return {0, -1};
  }
}

// return the indices
template <typename T, typename Op>
std::vector<i64> findall(Op &&fn, const std::vector<T> &h) {
  const auto n = h.size();
  std::vector<i64> ret;
  ret.reserve(n);
  for (size_t i = 0; i < n; ++i) {
    if (fn(h[i])) {
      ret.emplace_back(i);
    }
  }
  return ret;
}
template <typename T> T prod(const std::vector<T> &x) {
  auto ret = foldl(T(1), x, [](const T &a, const T &b) -> T { return a * b; });
  return ret;
}
static inline i64 to_int(std::string_view s) {
  return std::stoll(std::string(s));
}

template <typename T, typename U>
std::vector<std::pair<T, U>> zip(const std::vector<T> &a,
                                 const std::vector<U> &b) {
  std::vector<std::pair<T, U>> ret;

  for (size_t i = 0; i < std::min(a.size(), b.size()); ++i) {
    ret.emplace_back(a[i], b[i]);
  }
  return ret;
}

static inline Maybe<i64> try_int(std::string_view s) {
  try {
    return {1, std::stoll(std::string(s))};
  } catch (...) {
    return {0, {}};
  }
}

static inline bool inRange(std::string_view str, int min, int max) {
  auto num = try_int(str);
  if (!num.has_value) {
    return false;
  }

  return min <= num.unwrap && num.unwrap <= max;
}

template <typename T> static inline bool match(const T &) { return true; }

template <typename T, typename R>
static inline bool match(const T &lhs, const R &rhs) {
  return (lhs == rhs);
}

template <typename T, typename U, typename... Args>
static inline bool match(const T &first, const U &second, const Args &...rest) {
  return (first == second) || match(first, rest...);
}

template <typename T, typename R>
static inline std::vector<std::pair<T, R>> cartesian(const std::vector<T> &xs,
                                                     const std::vector<R> &ys) {

  std::vector<std::pair<T, R>> ret;
  for (const auto &x : xs) {
    for (const auto &y : ys) {
      ret.emplace_back(x, y);
    }
  }
  return ret;
}

} // namespace utils

#endif // UTILS_HPP__

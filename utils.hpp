#ifndef UTILS_HPP__
#define UTILS_HPP__

#include <algorithm>
#include <assert.h>
#include <iostream>
#include <limits>
#include <string>
#include <string_view>
#include <vector>
#include <cstdint>

using c8 = char;

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

template <typename T>
using Vec = std::vector<T>;

namespace utils {

struct V2 {
  i32 x{0};
  i32 y{0};
  V2() {}
  V2(i32 x, i32 y) : x(x), y(y) {}
};

inline V2 operator+(const V2 &a, const V2 &b) { return {a.x + b.x, a.y + b.y}; }
inline V2 operator-(const V2 &a, const V2 &b) { return {a.x - b.x, a.y - b.y}; }
inline bool operator==(const V2 &a, const V2 &b) {
  return a.x == b.x && a.y == b.y;
}
inline bool operator<(const V2 &a, const V2 &b) {
  return a.x < b.x ? true : (b.x < a.x ? false : (a.y < b.y ? true : false));
}
inline bool operator>(const V2 &a, const V2 &b) { return b < a; }
inline bool operator!=(const V2 &a, const V2 &b) { return !(a == b); }
inline bool operator<=(const V2 &a, const V2 &b) { return !(b < a); }
inline bool operator>=(const V2 &a, const V2 &b) { return !(a < b); }

double manhattan_dist(const V2 &a, const V2 &b) {
  return std::abs(b.x - a.x) + std::abs(b.y - a.y);
}

template <typename T>
struct tV2 {
  T x{0};
  T y{0};
  tV2() {}
  tV2(T x, T y) : x(x), y(y) {}
};

template <typename T>
struct V3 {
  T x{0};
  T y{0};
  T z{0};
  V3() {}
  V3(T x, T y, T z) : x(x), y(y), z(z) {}
};

// mod that works
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
  std::size_t rows, cols;
  T *data{nullptr};

  Matrix(std::size_t r, std::size_t c) : rows(r), cols(c) { data = new T[rows * cols](); }
  Matrix(const Matrix<T> &m) : rows(m.rows), cols(m.cols), data(m.data) {}
  Matrix(Matrix<T> &&m) : rows(m.rows), cols(m.cols), data(std::move(m.data)) {}
  template <std::size_t r, std::size_t c> Matrix(T (&m)[r][c]) : Matrix(r, c) {
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
  create_mat_from_lines(const Vec<std::string_view> &lines) {
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

template <typename T> Matrix<T> hcat(const Vec<Matrix<T>> &vec) {
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

template <typename T, typename TIter = decltype(std::begin(std::declval<T>())),
          typename = decltype(std::end(std::declval<T>()))>
constexpr auto enumerate(T &&iterable) {
  struct iterator {
    size_t i;
    TIter iter;
    bool operator!=(const iterator &other) const { return iter != other.iter; }
    void operator++() {
      ++i;
      ++iter;
    }
    auto operator*() const { return std::tie(i, *iter); }
  };
  struct iterable_wrapper {
    T iterable;
    auto begin() { return iterator{0, std::begin(iterable)}; }
    auto end() { return iterator{0, std::end(iterable)}; }
  };
  return iterable_wrapper{std::forward<T>(iterable)};
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
join_string_view(const Vec<std::string_view> &vec) {
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

static inline Vec<std::string_view> split_lines(std::string_view view,
                                                        char delim = '\n') {
  Vec<std::string_view> ret;

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

static inline Vec<std::string_view> split_by(std::string_view view,
                                                     std::string_view delim) {
  view = trimr(view);
  Vec<std::string_view> ret;
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

static inline Vec<std::string_view> split_by(std::string_view view,
                                                     char delim) {
  return split_by(view, std::string_view(&delim, 1));
}

static inline Vec<std::string_view>
read_lines_as_string_view(const char *filename) {
  auto lines = read_file_as_string_view(filename);
  return split_lines(lines, '\n');
}

template <typename T, typename Op>
Vec<T> filter(Op &&fn, const Vec<T> &v) {

  const auto n = v.size();
  Vec<T> ret;
  ret.reserve(n);
  for (auto &&val : v) {
    if (fn(val)) {
      ret.emplace_back(val);
    }
  }
  return ret;
}

template <typename... Types>
std::size_t GetVectorsSize(const Vec<Types> &...vs) {
  constexpr const auto nArgs = sizeof...(Types);
  const std::size_t sizes[] = {vs.size()...};
  if (nArgs > 1) {
    for (size_t i = 1; i < nArgs; ++i) {
      if (sizes[0] == sizes[i]) {
        continue;
      }
      fprintf(stderr, "Vectors have different lenght\n");
      exit(1);
    }
  }
  return sizes[0];
}

template <typename F, typename... Types>
auto map(F &&fn, const Vec<Types> &...input)
    -> Vec<decltype(fn(input[0]...))> {
  const auto size = GetVectorsSize(input...);
  Vec<decltype(fn(input[0]...))> ret(size);
  for (size_t i = 0; i < size; ++i) {
    ret[i] = fn(input[i]...);
  }
  return ret;
}

template <typename T, typename Op>
auto map(Op &&fn, const Vec<T> &input)
    -> Vec<decltype(fn(input[0]))> {
  Vec<decltype(fn(input[0]))> ret;
  ret.reserve(input.size());
  for (const auto &x : input) {
    ret.push_back(fn(x));
  }
  return ret;
}

template <typename T, typename R, typename FoldOp>
R foldl(const R &i, const Vec<T> &xs, FoldOp fn) {
  auto ret = i;
  for (const auto &x : xs) {
    ret = fn(ret, x);
  }
  return ret;
}

template <typename T> static inline T sum(const Vec<T> &xs) {
  return foldl(T(), xs, [](const T &a, const T &b) -> T { return a + b; });
}

template <typename T>
static inline Vec<T> arange(T start, T stop, T step = 1) {
  Vec<T> values;

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
template <typename F, typename T>
Maybe<i64> findfirst(F &&fn, const Vec<T> &h) {
  auto res = std::find_if(h.begin(), h.end(), fn);
  if (res != h.end()) {
    return {1, std::distance(h.begin(), res)};
  } else {
    return {0, -1};
  }
}

// return the indices
template <typename F, typename T>
Vec<i64> findall(F &&fn, const Vec<T> &h) {
  const auto n = h.size();
  Vec<i64> ret;
  ret.reserve(n);
  for (size_t i = 0; i < n; ++i) {
    if (fn(h[i])) {
      ret.emplace_back(i);
    }
  }
  return ret;
}
template <typename T> T prod(const Vec<T> &x) {
  auto ret = foldl(T(1), x, [](const T &a, const T &b) -> T { return a * b; });
  return ret;
}
static inline i64 to_i64(std::string_view s) {
  return std::stoll(std::string(s));
}

static inline i32 to_i32(std::string_view s) {
  return std::stoi(std::string(s));
}

template <typename T, typename U>
Vec<std::pair<T, U>> zip(const Vec<T> &a,
                                 const Vec<U> &b) {
  Vec<std::pair<T, U>> ret;

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
static inline Vec<std::pair<T, R>> cartesian(const Vec<T> &xs,
                                                     const Vec<R> &ys) {

  Vec<std::pair<T, R>> ret;
  for (const auto &x : xs) {
    for (const auto &y : ys) {
      ret.emplace_back(x, y);
    }
  }
  return ret;
}


template <typename T, typename U>
Vec<std::pair<T, U>> zip(const Vec<T> &a,
                         const Vec<U> &b, i64 shift_1 = 0, i64 shift_2 = 0)
{
    Vec<std::pair<T, U>> ret;

    // TODO: check if shifts trigger out of bounds
    const auto n = std::min(a.size(), b.size()) - std::max(shift_1, shift_2);
    ret.reserve(n);
    for (std::size_t i = 0; i < n; ++i)
    {
        ret.emplace_back(a[i + shift_1], b[i + shift_2]);
    }
    return ret;
}

} // namespace utils

#endif // UTILS_HPP__

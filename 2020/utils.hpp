#ifndef UTILS_HPP__
#define UTILS_HPP__

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

//////////////////////////////////////////////////
// Matrix
//////////////////////////////////////////////////
template <typename T> struct Matrix {
  size_t rows, cols;
  T *data{nullptr};

  Matrix(size_t r, size_t c) : rows(r), cols(c) { data = new T[rows * cols](); }
  Matrix(const Matrix<T> &m) : rows(m.rows), cols(m.cols), data(m.data) {}
  Matrix(Matrix<T> &&m) : rows(m.rows), cols(m.cols), data(std::move(m.data)) {}

  T &operator()(size_t i, size_t j) { return data[j + i * cols]; }

  const T &operator()(size_t i, size_t j) const { return data[j + i * cols]; }

  void diagonal(T d = (T)1.0) {
    for (size_t i = 0; i < rows; ++i) {
      for (size_t j = 0; j < cols; ++j) {
        if (i == j) {
          (*this)(i, j) = d;
        }
      }
    }
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

static inline std::string_view readFileRaw(const std::string &path) {
  FILE *f = fopen(path.c_str(), "r");
  if (!f)
    fprintf(stderr, "failed to open file '%s'\n", path.c_str()), abort();

  std::string input;
  {
    fseek(f, 0, SEEK_END);

    long fsize = ftell(f);
    fseek(f, 0, SEEK_SET); // same as rewind(f);

    char *s = new char[fsize + 1];
    fread(s, fsize, 1, f);
    fclose(f);
    s[fsize] = 0;

    size_t n = fsize - 1;
    while (n > 0 && s[n] == '\n')
      n--;

    return std::string_view(s, n + 1);
  }
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
  if (i != -1)
    s = s.substr(0, i + 1);

  return s;
}

static inline std::string_view &triml(std::string_view &s) {
  auto i = s.find_first_not_of(" \t\n\r\f\v");
  if (i != -1)
    s.remove_prefix(i);

  return s;
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
                                                     char delim) {
  view = trimr(view);
  std::vector<std::string_view> ret;
  while (view.size() > 0) {
    auto len = view.find(delim);
    if (len == std::string_view::npos) {
      ret.push_back(view);
      break;
    }
    ret.push_back(view.substr(0, len));
    view = view.substr(len + 1);
  }
  return ret;
}

static inline std::vector<std::string_view>
read_lines_as_string_view(const char *filename) {
  auto lines = read_file_as_string_view(filename);
  return split_lines(lines, '\n');
}

template <typename T, typename Op>
auto map(const std::vector<T> &input, Op fn)
    -> std::vector<decltype(fn(input[0]))> {
  std::vector<decltype(fn(input[0]))> ret;
  ret.reserve(input.size());
  for (const auto &x : input) {
    ret.push_back(fn(x));
  }
  return ret;
}

static inline int to_int(std::string_view s) {
  return std::stoi(std::string(s));
}

// static inline std::vector<std::string_view> readGrid(const std::string &path)
// {}
} // namespace utils

#endif // UTILS_HPP__

const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
  const tokenHeader = req.header('Authorization');

  console.log(tokenHeader);
  if (!tokenHeader) {
    return res.status(401).json({ message: 'Acces interzis - Token lipsește' });
  }

  const tokenParts = tokenHeader.split(' ');
  if (tokenParts.length !== 2 || tokenParts[0] !== 'Bearer') {
    return res.status(401).json({ message: 'Acces interzis - Format de token invalid' });
  }

   const token = tokenParts[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET); // Înlocuiește 'secretKey' cu cheia reală
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(403).json({ message: 'Token invalid' });
  }
};

module.exports = authenticateToken;
